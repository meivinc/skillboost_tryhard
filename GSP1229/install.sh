# STEP 1 
git clone https://github.com/GoogleCloudPlatform/generative-ai.git
cd generative-ai/gemini/sample-apps/gemini-streamlit-cloudrun
AR_REPO='gemini-repo'
SERVICE_NAME='gemini-streamlit-app' 
# Creation of artifact registry 
gcloud artifacts repositories create "$AR_REPO" --location="$GCP_REGION" --repository-format=Docker

# Build the image from docker file 
gcloud builds submit --tag "$GCP_REGION-docker.pkg.dev/$GCP_PROJECT/$AR_REPO/$SERVICE_NAME"

# Deploy the app 
gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$GCP_REGION-docker.pkg.dev/$GCP_PROJECT/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$GCP_REGION \
  --platform=managed  \
  --project=$GCP_PROJECT \
  --set-env-vars=GCP_PROJECT=$GCP_PROJECT,GCP_REGION=$GCP_REGION


echo "You're done Congratz"