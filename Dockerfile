FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

ARG AWS_ACCESS
ARG AWS_BUCKET
ARG AWS_REGION
ARG AWS_SECRET

WORKDIR /

RUN apt-get update && \
    apt-get -y install git cmake g++ libgl1-mesa-glx libglib2.0-0 wget

RUN conda install -y -c conda-forge cudatoolkit-dev

RUN pip install --upgrade pip
RUN pip install potassium


RUN git clone https://github.com/luca-medeiros/lang-segment-anything


ENV AWS_ACCESS=${AWS_ACCESS}
ENV AWS_BUCKET=${AWS_BUCKET}
ENV AWS_REGION=${AWS_REGION}
ENV AWS_SECRET=${AWS_SECRET}

ADD download.py .
RUN python3 download.py

ADD . .

EXPOSE 8000

CMD echo 'Running check_gpu.py' && python3 check_gpu.py && echo 'Changing directory to lang-segment-anything' && cd lang-segment-anything && echo 'Installing torch and torchvision' && pip install torch torchvision && echo 'Installing current directory as package' && pip install -e . && echo 'Changing directory back to parent' && cd .. && echo 'Running app.py' && python3 -u app.py
#CMD ["sh", "-c", "echo 'Running check_gpu.py' && python3 check_gpu.py && echo 'Changing directory to lang-segment-anything' && cd lang-segment-anything && echo 'Installing torch and torchvision' && pip install torch torchvision && echo 'Installing current directory as package' && pip install -e . && echo 'Changing directory back to parent' && cd .. && echo 'Running app.py' && python3 -u app.py"]
#CMD ["sh", "-c", "python3 check_gpu.py && cd lang-segment-anything && pip install -v torch torchvision && pip install -v -e . && cd .. && python3 -u app.py"]
#CMD ["sh", "-c", "python check_gpu.py && pip install -v torch torchvision && pip install -v -e . && python -u app.py"]
#CMD ["sh", "-c", "python3 check_gpu.py && pip install -v torch torchvision && pip install -v -e . && python3 -u app.py"]
#CMD python3 -u app.py