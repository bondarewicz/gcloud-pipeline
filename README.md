# gcloud-pipeline

see https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=en_US&_ga=2.141057842.-1257725333.1526045030

```
npm install 
gcloud auth configure-docker
docker build -t gcr.io/gcloud-pipeline/gcloud-pipeline:0.0.16 .   
docker run -p 8080:8080 -d gcr.io/gcloud-pipeline/gcloud-pipeline:0.0.16
docker push gcr.io/gcloud-pipeline/gcloud-pipeline:0.0.16