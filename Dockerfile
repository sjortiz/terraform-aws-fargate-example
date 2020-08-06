FROM python:3.8-alpine

COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt
COPY api /api
WORKDIR /api
CMD python app.py
