ARG PLATFORM
ARG ROS_DISTRO
FROM ghcr.io/autowarefoundation/autoware-openadk:base-${ROS_DISTRO}-${PLATFORM} as base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PLATFORM
ARG ROS_DISTRO

# Copy install folder from prebuilt
FROM ghcr.io/autowarefoundation/autoware-openadk:prebuilt-${ROS_DISTRO}-${PLATFORM} as prebuilt
FROM base as visualizer
COPY --from=prebuilt /autoware/install/ /autoware/install/
COPY autoware.repos /autoware/

# Bugfix rviz2 black-screen problem with some nvidia drivers: https://github.com/ros2/rviz/issues/948
RUN apt update && apt install -y software-properties-common && add-apt-repository ppa:kisak/kisak-mesa && apt install -y \
  libegl-mesa0 libegl1-mesa-dev libgbm-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri libglapi-mesa libglx-mesa0 ros-humble-rviz2

# Create entrypoint
COPY docker/autoware-openadk/etc/ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

# Copy simulation files
RUN mkdir -p /autoware/scenario-sim
COPY docker/autoware-openadk/etc/simulation/ /autoware/scenario-sim/

# Copy bash aliases
COPY docker/autoware-openadk/services/visualizer/.bash_aliases /root/.bash_aliases

# Create entrypoint
RUN echo "source /autoware/install/setup.bash" > /etc/bash.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]