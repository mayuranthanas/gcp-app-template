FROM python:3

ADD /src/main.py /

RUN pip3 install google.cloud
RUN pip3 install google.cloud.logging
RUN pip3 install google.cloud.pubsub
RUN pip3 install flask

CMD [ "python3", "./main.py" ]