# gcloud-pipeline

see https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=en_US&_ga=2.141057842.-1257725333.1526045030

```
npm install 
gcloud auth configure-docker
docker build -t eu.gcr.io/parcel-vision/gcloud-pipeline:0.0.34 .   
docker run -p 8080:8080 -d eu.gcr.io/parcel-vision/gcloud-pipeline:0.0.34
docker push eu.gcr.io/parcel-vision/gcloud-pipeline:0.0.34
```