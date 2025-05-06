
mkdir myapp
cd myapp
curl -L -O -J https://github.com/GoogleCloudPlatform/generative-ai/tree/main/gemini/sample-apps/gemini-streamlit-cloudrun -o gemini-streamlit-cloudrun.zip
unzip gemini-streamlit-cloudrun

curl -L -o Dockerfile https://github.com/GoogleCloudPlatform/generative-ai/blob/main/gemini/sample-apps/gemini-streamlit-cloudrun/Dockerfile
curl -L -o  https://github.com/GoogleCloudPlatform/generative-ai/blob/main/gemini/sample-apps/gemini-streamlit-cloudrun/app.py
curl -L -o requirements.txt https://github.com/GoogleCloudPlatform/generative-ai/blob/main/gemini/sample-apps/gemini-streamlit-cloudrun/requirements.txt

SERVICE_NAME='gemini-streamlit-app' 
GCP_PROJECT='qwiklabs-gcp-01-46ae4886faeb'
GCP_REGION='us-east4'
gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="vincentmeindl/genaiskillboost:latest" \
  --allow-unauthenticated \
  --region=$GCP_REGION \
  --platform=managed  \
  --project=$GCP_PROJECT \
  --set-env-vars=GCP_PROJECT=$GCP_PROJECT,GCP_REGION=$GCP_REGION





mkdir test
cd test
AR_REPO='gemini-repo'
SERVICE_NAME='gemini-streamlit-app' 
cat <<EOF > Dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["python", "app.py"]
EOF

cat <<EOF > app.py
from http.server import BaseHTTPRequestHandler, HTTPServer

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b"<h1>Hello from port 8080!</h1>")

if __name__ == '__main__':
    server_address = ('', 8080)
    httpd = HTTPServer(server_address, SimpleHandler)
    print('Starting server on port 8080...')
    httpd.serve_forever()
EOF

gcloud artifacts repositories create "$AR_REPO" --location="$GCP_REGION" --repository-format=Docker
gcloud builds submit --tag "$GCP_REGION-docker.pkg.dev/$GCP_PROJECT/$AR_REPO/$SERVICE_NAME"
gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$GCP_REGION-docker.pkg.dev/$GCP_PROJECT/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$GCP_REGION \
  --platform=managed  \
  --project=$GCP_PROJECT \
  --set-env-vars=GCP_PROJECT=$GCP_PROJECT,GCP_REGION=$GCP_REGION

# website::tag::1:: Build a simple Docker image that contains a text file with the contents "Hello, World!"
FROM ubuntu:18.04
RUN echo 'Hello, World!' > /test.txt
# echo -e 'FROM ubuntu:18.04\nEXPOSE 8080\nRUN echo \"Hello, World!\" > /test.txt' > Dockerfile

