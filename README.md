# ProjectSearch
Dispositivo de Busqueda e Inspección de Desastres

# Objetivo: 
El objetivo de este dispositivo consiste en localizar personas dentro de lugares donde el humano no pueda acceder para detectar cuerpos atrapados, mandar sonidos de alerta y localización GPS de los cuerpos asi como la posibilidad de escuchar el ruido de las personas permitiendo también que los individuos se comuniquen por medio de un micrófono el cual manda las señales a la aplicación de comunicación con el dispositivo.

# Enunciado de visión:
El proyecto dispositivo de búsqueda e inspección tiene como vision lograr ser un dispositivo completo que mantenga su objetivo de búsqueda e inspección ayudando en situaciones de desastre con una carga que resista el tiempo de búsqueda.


#Software empleado: Arduino IDE, ThingSpeak

# Hardware empleado
| Nombre | Componente | Descripción | Cantidad |
|----|-------|----|---|
|NODE MCU ESP32|![image](https://github.com/javajasso/ProjectSearch/assets/93737169/03dd9424-4540-4a07-9e8f-5e1f08c4cb89)
|Con el NodeMCU-ESP32, es posible crear prototipos cómodamente con una programación sencilla a través de Luascript o el IDE de Arduino y el diseño compatible con la placa de pruebas. Esta placa tiene Wifi de modo dual de 2,4 GHz y una conexión inalámbrica BT.
Además, una SRAM de 512 KB y una memoria flash de 4 MB están integradas en la placa de desarrollo del microcontrolador. La placa tiene 21 pines para la conexión de interfaz, incluidos I2C, SPI, UART, DAC y ADC.
|1|

|Dht11|![image](https://github.com/javajasso/ProjectSearch/assets/93737169/f2e8bf84-a87c-41a5-888c-6f86de377835)
|El DHT11 es un sensor simple que mide temperatura y humedad, todo en uno. Tiene alta fiabilidad y estabilidad debido a su señal digital calibrada|1|

|Buzzer|![image](https://github.com/javajasso/ProjectSearch/assets/93737169/fdf3f22d-862e-4574-a2fc-a1028c30f91e)
|Un zumbador o mejor conocido como buzzer (en ingles) es un pequeño transductorcapaz de convertir la energía eléctrica en sonido.|1|
|Cables Arduino |![image](https://github.com/javajasso/ProjectSearch/assets/93737169/851f00bb-ed55-4c04-9ffa-8c66cb992167)
|Los cables de conexión se utilizan para conectar componentes electrónicos externos, como sensores, actuadores y pantallas, a la placa|10|
|Cable USB|![image](https://github.com/javajasso/ProjectSearch/assets/93737169/7c40b703-214c-4b81-858b-c1aec9a99d6a)
|El Cable Micro USB para ESP32 es una herramienta esencial para programar y alimentar tu placa IoT. Diseñado con conectores de alta calidad, proporciona una conexión rápida y fiable, asegurando una programación sin complicaciones|1|


#Historias de usuario épicas:
historias involucradas en el primer sprint de la unida 1

|ID |Usuario|Función Dispositivo|Explicación de Funcionalidad| Prioridad | Sprint | Como Probarlo |
|HU005|Personas Atrapadas|Bocina (Alarma)|Cuando la situación sea muy grave el dispositivo permite al usuario activar la alarma para ser encontrados más rápido en zonas críticas o de difícil acceso y que se activa cuando la temperatura del sitio está en niveles críticos|Se podría incluir|2|El dispositivo permanece en un solo sitio perpetuando la ubicación GPS o en su defecto si la localización falla por la zona de difícil acceso el dispositivo emite la alarma de sonido para ser encontrado|
|HU008|Equipo de búsqueda y rescate|Sensor de Temperatura del Ambiente|El equipo puede monitorear la temperatura ambiente de la zona del derrumbe para informar el estado de las personas dentro del sitio|Se podría incluir|3|El dispositivo emitirá los niveles de temperatura del ambiente donde se encuentre hacia la aplicación de monitoreo|


#  Dibujo del Prototipo
Fotografía tomada del dibujo del prototipo propuesto por el equipo para el proyecto <<se puede especificar con notas, no es obligatorio que sea dibujado puedes utilizar cualquier software que permita su diseño profesional>> 
![image](https://github.com/javajasso/ProjectSearch/assets/93737169/1aaf5cd9-58ce-493f-92be-9f9d5b03b00c)

# Arquitectura del proyecto
![image](https://github.com/javajasso/ProjectSearch/assets/93737169/0f94b254-0897-4dc8-aec4-c60eed2c0fdf)

# Captura de pantalla del tablero kanban para cada uno de los sprints del proyecto.
![image](https://github.com/javajasso/ProjectSearch/assets/93737169/4bb7eaad-5804-434f-8133-7d560f08b141)


# Circuito diseñado para el proyecto completo:
![image](https://github.com/javajasso/ProjectSearch/assets/93737169/42d3cd14-10b8-4fcf-9409-e8c64c7f9cdf)


# Video del Sprint Unidad 1

