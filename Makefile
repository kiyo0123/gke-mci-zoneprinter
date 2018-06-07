POJECT=$(shell gcloud config list project --format="value(core.project)")
CLUSTER1=cluster-tokyo
CLUSTER1-ZONE=asia-northeast1-a
CLUSTER2=cluster-taiwan
CLUSTER2-ZONE=asia-east1-a
ZP_KUBEMCI_IP=zp-kubemci-ip
	
create-clusters:
	# Create a cluster in us-east and get its credentials	
	KUBECONFIG=clusters.yaml gcloud container clusters create \
    --cluster-version=1.9 \
    --zone=$(CLUSTER1-ZONE) \
    $(CLUSTER1)

	# Create a cluster in eu-west and get its credentials
	KUBECONFIG=clusters.yaml gcloud container clusters create \
    --cluster-version=1.9 \
    --zone=$(CLUSTER2-ZONE) \
    $(CLUSTER2)

delete-clusters:
	gcloud container clusters delete --zone $(CLUSTER1-ZONE) $(CLUSTER1)
	gcloud container clusters delete --zone $(CLUSTER2-ZONE) $(CLUSTER2) 

create-kubeconfig: 
	KUBECONFIG=clusters.yaml gcloud container clusters get-credentials $(CLUSTER1) --zone $(CLUSTER1-ZONE)
	KUBECONFIG=clusters.yaml gcloud container clusters get-credentials $(CLUSTER2) --zone $(CLUSTER2-ZONE)

delete-kubeconfig:
	rm clusters.yaml

create-mci:
	kubemci create zone-printer \
    --ingress=ingress/ingress.yaml \
    --gcp-project=$(PROJECT) \
    --kubeconfig=clusters.yaml

delete-mci:
	kubemci delete zone-printer \
    --ingress=ingress/ingress.yaml \
    --gcp-project=$(PROJECT) \
    --kubeconfig=clusters.yaml

deploy-app:
	bash -x "./scripts/deployapp.sh"

delete-app:
	bash -x "./scripts/deleteapp.sh"
	
create-ip:
	gcloud compute addresses create --global "${ZP_KUBEMCI_IP}"

delete-ip:
	gcloud compute addresses delete "${ZP_KUBEMCI_IP}"
