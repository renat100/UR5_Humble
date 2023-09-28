FROM osrf/ros:humble-desktop-full

RUN apt-get update && apt-get install -y nano && rm -rf /var/lib/apt/lists/*



ARG USERNAME=ros_humble
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config
#Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

#Installare le dipendenze necessarie x compilare UR_driver
RUN mkdir -p /Src_for_dep_driver/src/
COPY src /Src_for_dep_driver/src
WORKDIR /Src_for_dep_driver/
RUN apt-get update && apt-get install -y --no-install-recommends; \
  rosdep update --include-eol-distros; \
  sudo apt-get update

RUN rosdep install --ignore-src --from-paths src -y -r --rosdistro humble 
RUN rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -y --no-install-recommends \
  ros-humble-gazebo-ros-pkgs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /App/

COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["bash"]