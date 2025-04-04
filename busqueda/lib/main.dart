import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:fl_chart/fl_chart.dart';

class VideoFromCamera extends StatefulWidget {
  const VideoFromCamera({super.key});

  @override
  _VideoFromCameraState createState() => _VideoFromCameraState();
}

class _VideoFromCameraState extends State<VideoFromCamera> {
  final String videoUrl = 'http://192.168.174.25:81/stream';
  final String captureUrl = 'http://192.168.174.25/capture';
  final String mongoApiUrl = 'https://serversearch.onrender.com/uploadImage'; // URL para guardar la imagen
  Timer? _timer;

  // Variables para almacenar los datos
  double temperature = 0.0;
  double humidity = 0.0;
  double soundAnalog = 0.0;
  double soundDigital = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;

  List<FlSpot> temperatureData = [];
  List<FlSpot> humidityData = [];
  List<FlSpot> soundData = [];
  int dataIndex = 0;
   List<double> latitudeHistory = [];
  List<double> longitudeHistory = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t)
    {
      //_captureImage();
      _fetchSensorData();
    });

    
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Método para capturar una imagen y enviarla
  Future<void> _captureImage() async {
    try {
      final response = await http.get(Uri.parse(captureUrl));
      if (response.statusCode == 200) {
        Uint8List imageData = response.bodyBytes;
        _showCapturedImage(imageData, 'Captura automática');
        // Enviar la imagen al servidor MongoDB
        _sendImageToMongoDB(imageData);
      } else {
        print('Error al capturar imagen: ${response.statusCode}');
      }
    } catch (e) {
      print("Error al capturar imagen: $e");
    }
  }

  // Función para enviar la imagen al servidor MongoDB
  Future<void> _sendImageToMongoDB(Uint8List imageData) async {
    try {
      // Convertir la imagen en Base64
      String base64Image = base64Encode(imageData);

      // Crear el cuerpo de la solicitud POST
      Map<String, String> body = {
        'image': base64Image,
        'timestamp': DateTime.now().toIso8601String(),  // Enviar la fecha y hora como parte de los datos
      };

      // Enviar la imagen al servidor
      final response = await http.post(
        Uri.parse(mongoApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Imagen enviada correctamente a MongoDB");
      } else {
        print("Error al enviar imagen: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al enviar imagen a MongoDB: $e");
    }
  }

  // Función para obtener los datos de la API
Future<void> _fetchSensorData() async {
  try {
    final response = await http.get(Uri.parse('https://serversearch.onrender.com/data'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Respuesta de la API: $data");

      if (data is List) {  // Asegurarse de que la respuesta es una lista
        for (var item in data) {
          // Verificar si el objeto contiene la clave 'data'
          if (item.containsKey('data')) {
            final sensorData = item['data'];

          // Verificar que 'data' no esté vazw  +
          // {.jklñ{cío
            if (sensorData != null) {
              print("Datos de los sensores: $sensorData");

              setState(() {
                // Convertir los valores a double (si es necesario) usando .toDouble()
                temperature = (sensorData['temperature'] ?? 0.0).toDouble();
                humidity = (sensorData['humidity'] ?? 0.0).toDouble();
                soundAnalog = (sensorData['soundAnalog'] ?? 0.0).toDouble();
                soundDigital = (sensorData['soundDigital'] ?? 0.0).toDouble();
                latitude = (sensorData['latitude'] ?? 0.0).toDouble();
                longitude = (sensorData['longitude'] ?? 0.0).toDouble();

                // Actualizar los gráficos con los nuevos datos
                temperatureData.add(FlSpot(dataIndex.toDouble(), temperature));
                humidityData.add(FlSpot(dataIndex.toDouble(), humidity));
                soundData.add(FlSpot(dataIndex.toDouble(), soundAnalog));
                
                // Agregar latitud y longitud al historial
                latitudeHistory.add(latitude);
                longitudeHistory.add(longitude);

                // Limitar la cantidad de datos mostrados (máximo 100 puntos)
                if (temperatureData.length > 20) {
                  temperatureData.removeAt(0); // Eliminar el primer dato si superamos los 20 puntos
                }

                if (humidityData.length > 20) {
                  humidityData.removeAt(0);
                }

                if (soundData.length > 20) {
                  soundData.removeAt(0);
                }

                if (latitudeHistory.length > 10) {
                  latitudeHistory.removeAt(0);
                }

                if (longitudeHistory.length > 10) {
                  longitudeHistory.removeAt(0);
                }

                dataIndex++;
              });
            }
          } else {
            print("El objeto no contiene la clave 'data'. Se omite: $item");
          }
        }
      } else {
        print('La respuesta no es una lista.');
      }
    } else {
      print('Error al obtener datos: ${response.statusCode}');
    }
  } catch (e) {
    print("Error al obtener datos: $e");
  }
}




  // Mostrar la imagen capturada
  void _showCapturedImage(Uint8List imageData, String source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(source),
        content: Image.memory(imageData),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Project Search',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
            tabs: [
              Tab(icon: Icon(Icons.videocam)),
              Tab(icon: Icon(Icons.pie_chart)),
              Tab(icon: Icon(Icons.line_weight)),
              Tab(icon: Icon(Icons.assessment)),
            ],
          ),
          backgroundColor: Colors.blue[900],
        ),
        body: TabBarView(
          children: [
            // Primera pestaña: Video
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Mjpeg(
                    stream: videoUrl,
                    error: (context, error, stackTrace) {
                      return Center(child: Text('Error loading video'));
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Mostrar los datos en la interfaz
                      Text('Temperatura: ${temperature.toString()} °C'),
                      Text('Humedad: ${humidity.toString()} %'),
                      Text('Sonido (Analógico): ${soundAnalog.toString()} dB'),
                      Text('Sonido (Digital): ${soundDigital.toString()}'),
                      Text('Latitud: ${latitude.toString()}'),
                      Text('Longitud: ${longitude.toString()}'),
                      ElevatedButton(
                        onPressed: _captureImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Tomar Foto y Guardar en Nube'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
           // Segunda pestaña: Gráficos de Temperatura y Humedad (Lineales)
// Segunda pestaña: Gráficos de Temperatura y Humedad (Lineales)
Padding(
  padding: EdgeInsets.all(8.0),
  child: Column(
    children: <Widget>[
      Text(
        'Temperatura y Humedad',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10.0),
      
      // Gráfico de Temperatura
      Expanded(
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: temperatureData,  // Datos de temperatura
                isCurved: true,
                color: Colors.blue,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
      
      SizedBox(height: 20), // Espacio entre los dos gráficos

      // Gráfico de Humedad
      Expanded(
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: humidityData,  // Datos de humedad
                isCurved: true,
                color: Colors.green,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)
,
// Tercera pestaña: Gráficos de líneas
Padding(
  padding: EdgeInsets.all(8.0),
  child: Column(
    children: [
      Text(
        'Niveles de Ruido',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      // Reducir un 5% el tamaño del gráfico ajustando el padding y el uso de Expanded
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0), // Aumentamos el padding a la izquierda para ampliar el eje Y
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // Aseguramos que el eje Y tenga suficiente espacio
                    reservedSize: 40.0,  // Aumentamos el tamaño reservado para el eje Y
                    getTitlesWidget: (value, titleMeta) {
                      return Text(
                        value.toStringAsFixed(0),  // Mostramos el valor exacto sin decimales
                        style: TextStyle(fontSize: 12),  // Tamaño ajustado para los valores del eje Y
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,  // Deshabilitar títulos en el eje X si no los necesitas
                  ),
                ),
                // Deshabilitar el eje derecho y el eje superior
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                if (soundData.isNotEmpty)
                  LineChartBarData(
                    spots: soundData,
                    isCurved: true,
                    color: Colors.red,
                    belowBarData: BarAreaData(show: false),
                  ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),

            
// Cuarta pestaña: Gráfico de Historial de Latitud y Longitud
Padding(
  padding: EdgeInsets.all(8.0),
  child: Column(
    children: [
      Text(
        'Historial de Latitud y Longitud',
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10.0),
      
      // Gráfico de Latitud
      Expanded(
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(latitudeHistory.length, (index) {
                  return FlSpot(index.toDouble(), latitudeHistory[index]);
                }),
                isCurved: true,
                color: Colors.blue,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
      
      SizedBox(height: 20), // Espacio entre los gráficos
      
      // Gráfico de Longitud
      Expanded(
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(longitudeHistory.length, (index) {
                  return FlSpot(index.toDouble(), longitudeHistory[index]);
                }),
                isCurved: true,
                color: Colors.green,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)

,
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VideoFromCamera(),
  ));
}
