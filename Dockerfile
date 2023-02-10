FROM ros:noetic-perception
RUN apt-get update && \
    apt-get install -y git cmake libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev wget
RUN wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz && \
    tar zxf ceres-solver-2.1.0.tar.gz && \
    mkdir ceres-bin && \
    cd ceres-bin && \
    cmake ../ceres-solver-2.1.0 && \
    make -j2 && \
    make test && \
    make install 
RUN apt-get install -y libboost-all-dev python3-catkin-tools
#RUN add-apt-repository ppa:borglab/gtsam-develop && \
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:borglab/gtsam-release-4.0 -y
RUN apt-get update && \
    apt-get install -y libgtsam-dev libgtsam-unstable-dev
COPY FAST_LIO_SLAM /catkin_ws/src/FAST_LIO_SLAM
COPY livox_ros_driver /catkin_ws/src/livox_ros_driver
RUN cd /catkin_ws && \
    . /opt/ros/${ROS_DISTRO}/setup.sh && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y && \
    catkin config --install && \
    catkin_make -j1
