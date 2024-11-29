# JEH ESRGAN Dockerfile
# v1.0 2021-09-30
# Define base image
FROM nvidia/cuda:12.6.2-devel-ubuntu24.04

# Install sudo and create a sudo user
RUN apt update && apt install -y sudo \
    && useradd -m -s /bin/bash dockeruser \
    && echo 'dockeruser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the new user
USER dockeruser

# Set the working directory
WORKDIR /home/dockeruser

# Install git, curl and wget
RUN sudo apt install -y git curl wget

# Pull cuda-samples, make deviceQuery.
RUN git clone https://github.com/NVIDIA/cuda-samples.git \
    && cd cuda-samples/Samples/1_Utilities/deviceQuery \
     && make 

# Install Anaconda
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh \
     && bash Anaconda3-2024.10-1-Linux-x86_64.sh -b -p $HOME/anaconda3 \
        && rm Anaconda3-2024.10-1-Linux-x86_64.sh

# Initialize conda    
RUN ./anaconda3/bin/activate \
      && ./anaconda3/bin/conda init --all

# Add conda to PATH
ENV PATH="/home/dockeruser/anaconda3/bin:/home/dockeruser/anaconda3/condabin:${PATH}"

# Install pip
RUN conda install -y pip

# Clone Real-ESRGAN repository
RUN git clone https://github.com/xinntao/Real-ESRGAN.git

# Install Real-ESRGAN dependencies
RUN cd Real-ESRGAN \
    && pip install basicsr \
    && pip install facexlib \
    && pip install gfpgan \
    && pip install -r requirements.txt
    
# Uninstall the default pytorch installation (from requirements.txt)   
RUN pip uninstall -y torch \
    && pip uninstall -y torchvision

# Install PyTorch with CUDA support
RUN conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia

# Run Real-ESRGAN setup
RUN cd Real-ESRGAN \
&& python setup.py develop

# Install libgl1
RUN sudo apt install -y libgl1

# Copy esrgan.sh to the container and make it executable
COPY sync/esrgan.sh /home/dockeruser/esrgan.sh 
RUN sudo chmod +x esrgan.sh

# Modify basicsr/data/degradations.py to correct for deprecated import
RUN cd /home/dockeruser/anaconda3/lib/python3.12/site-packages/basicsr/data/ \
    && sed -i 's/from torchvision.transforms.functional_tensor import rgb_to_grayscale/from torchvision.transforms._functional_tensor import rgb_to_grayscale/g' degradations.py

# Set the default command to an interactive shell
CMD ["bash"]