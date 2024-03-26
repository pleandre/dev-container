FROM python:slim

# Create folders
WORKDIR /workspace/
RUN mkdir -p /workspace/scripts/tools/jupyter-lab/

# Copy requirements
COPY .github/workflows/requirements.txt /workspace/requirements.txt

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir --proxy=${http_proxy} -r /workspace/requirements.txt

# Run Python
ENTRYPOINT ["python", "-u", "/workspace/update-versions.py"]