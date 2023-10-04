# Docker
Per fare tutto (build del compose: build dell'immagine se non c'è già, instanzia containers se mancano e li avvia, fa anche l'attach ai servizi dei container solo dello stdo aprendo terminale dove va il log) digitare nel terminale sulla root della repo il seguente comando (nella cartella dove c'è compose.yml)
NOTA: Se è necessario forzare la build dell'immagine (x modifiche) aggiungere il parametro --build
```
docker compose up
```
Per visualizzare tutti i container istanziati in ogni stato (attivo/sospeso)
```
docker ps -a
```

Per aprire una shell verso il container già in stato di run:
attach (al servizio in esecuzione sul container, interfaccia in/out al servizio) vs bash (apro bash sul container) -> attach vs console su Portainer 
noto il nome del container (in questo caso il nome è sempre "ros_app"), comando
```
docker exec -it ros_app bash
```

# ROS
X COMPILARE SENZA ERRORI DRIVER UR
Scaricare pacchetti ros x gestire dipendenze

1 Per permettere di installare pacchetti ros anche di distro eol
```
rosdep update --include-eol-distros
sudo apt-get update
```
2 Gestione dipendenze 
```
rosdep install --ignore-src --from-paths src -y -r --rosdistro foxy
```
3 Compilazione con parametri
```
colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
```
Source
```
source install/setup.bash
```
# Launch file
Solo posa corrente su RVIZ OK
```
ros2 launch ur_robot_driver ur_control.launch.py ur_type:=ur5 robot_ip:=192.168.1.102 launch_rviz:=true
```
NB x fake hw aggiungere argomento: use_fake_hardware:=true

Dovrebbe eseguire traiettoria pianificata da Moveit (servono entrambi su terminali diversi)
ok posa robot, ok pianificazione ma fallisce esecuzione
```
ros2 launch ur_robot_driver ur_control.launch.py ur_type:=ur5 robot_ip:=192.168.1.102 launch_rviz:=false
```
```
ros2 launch ur_moveit_config ur_moveit.launch.py ur_type:=ur5 launch_rviz:=true
```
initial_joint_controller:=joint_trajectory_controller

# URScript

Eseguendo il driver, viene mandato in esecuzione il nodo "urscript_interface"
```
ros2 launch ur_robot_driver ur_control.launch.py ur_type:=ur5 robot_ip:=192.168.1.102 launch_rviz:=false
```
Si possono mandare i comandi pubblicando sul topic /urscript_interface/script_command delle stringhe (std_msgs/msg/String che ha solo il campo string data)

Esempi
Crea un popup sul Teach Pendant
```
ros2 topic pub /urscript_interface/script_command std_msgs/msg/String '{data: popup("hello")}' --once
```
Comando movej (raggiunge pos dei giunti in rad specificata con profilo trap)
NOTA: CONTROLLARE ORDINE DEI GIUNTI tra topic /joint_states e movej
```
ros2 topic pub /urscript_interface/script_command std_msgs/msg/String '{data: "movej([-1.01, -2.02, -1.9, 1.6, 0.03, 0.027], a=1.2, v=0.25, r=0)"}' --once
```
