FROM node:23.11-bullseye-slim
COPY --from=gcr.io/google.com/cloudsdktool/google-cloud-cli:455.0.0-slim  /usr/lib/google-cloud-sdk /usr/lib/google-cloud-sdk
# Add gcloud to PATH
ENV PATH=/usr/lib/google-cloud-sdk/bin:$PATH