# DEMO: GKE MCI(Multi Cluster Ingress) Zoneprinter
https://github.com/GoogleCloudPlatform/k8s-multicluster-ingress/blob/master/examples/zone-printer/README.md

## Step 0: 事前準備
1. ***GCP Project***
2. ***kubemci install***

## Step 1: クラスタの作成
#### GKE クラスタを新しく作成する
```shell
# Cluster 1 
KUBECONFIG=clusters.yaml gcloud container clusters create \
    --cluster-version=1.10 \
    --zone=asia-northeast1-a \
    cluster-tokyo

# Cluster 2
KUBECONFIG=clusters.yaml gcloud container clusters create \
    --cluster-version=1.10 \
    --zone=asia-east1-a \
    cluster-taiwan
```
またはMakefileを実行する。

```shell
    make create-clusters
```

#### 既存のGKEクラスタを利用する
```shell
KUBECONFIG=clusters.yaml gcloud container clusters \
    get-credentials cluster-tokyo --zone=asia-northeast1-a

KUBECONFIG=clusters.yaml gcloud container clusters \
    get-credentials cluster-taiwan --zone=asia-east1-a
    
# ...repeat for other clusters you would like to add to the Ingress
```


## Step 2: サンプルアプリケイーションをデプロイする
```shell
for ctx in $(kubectl config get-contexts -o=name --kubeconfig clusters.yaml); do
  kubectl --kubeconfig clusters.yaml --context="${ctx}" create -f manifests/
done
```

or 

```shell
make deploy-app
```

## Step 3: Static IPをリザーブする
```shell
ZP_KUBEMCI_IP="zp-kubemci-ip"
gcloud compute addresses create --global "${ZP_KUBEMCI_IP}"
```

## Step 4: kubemci をつかって multi-cluster Ingressをデプロイする
```shell
kubemci create zone-printer \
    --ingress=ingress/ingress.yaml \
    --gcp-project=$PROJECT \
    --kubeconfig=clusters.yaml
```

## Step 5: テストする
```shell
kubemci list
```

## Step 6: クリーンアップ
MCIを削除する。
```shell
kubemci delete zone-printer \
    --ingress=ingress/ingress.yaml \
    --gcp-project=$PROJECT \
    --kubeconfig=clusters.yaml
```
クラスタを削除する
```shell
gcloud container clusters delete cluster-tokyo --zone=asia-northeast1-a -q

gcloud container clusters delete cluster-taiwan --zone=asia-east1-a -q
```







