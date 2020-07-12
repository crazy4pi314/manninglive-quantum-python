FROM mcr.microsoft.com/quantum/iqsharp-base:0.12.2007.124

USER root
# Install additional system packages from apt.
RUN apt-get -y update && \
    apt-get -y install \
               # For the Python interoperability sample, we require QuTiP,
               # which in turn requires gcc's C++ support.
               g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/
RUN pip install cython \
                numpy \
                scipy && \
    pip install qutip RISE matplotlib

USER ${USER}
