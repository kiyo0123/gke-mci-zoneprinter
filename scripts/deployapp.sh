for ctx in $(kubectl config get-contexts -o=name --kubeconfig clusters.yaml); do
  kubectl --kubeconfig clusters.yaml --context="${ctx}" create -f manifests/
done

