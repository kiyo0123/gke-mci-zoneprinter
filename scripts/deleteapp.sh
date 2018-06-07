for ctx in $(kubectl config get-contexts -o=name --kubeconfig clusters.yaml); do 
		kubectl --kubeconfig clusters.yaml --context="${ctx}" delete -f manifests/
done

