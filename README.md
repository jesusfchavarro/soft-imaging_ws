# Taller de análisis de imágenes por software

## Propósito

Introducir el análisis de imágenes/video en el lenguaje de [Processing](https://processing.org/).

## Tareas

Implementar las siguientes operaciones de análisis para imágenes/video:

* Conversión a escala de grises.
* Aplicación de algunas [máscaras de convolución](https://en.wikipedia.org/wiki/Kernel_(image_processing)).
* (solo para imágenes) Despliegue del histograma.
* (solo para imágenes) Segmentación de la imagen a partir del histograma.
* (solo para video) Medición de la [eficiencia computacional](https://processing.org/reference/frameRate.html) para las operaciones realizadas.

Emplear dos [canvas](https://processing.org/reference/PGraphics.html), uno para desplegar la imagen/video original y el otro para el resultado del análisis.

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| Jesus F. Chavarro | jesusfchavarro |

## Discusión

1. En la conversión de la escala de grises se emplearon varias estrategias, la utilización del brillo, el promedio de los colores y el promedio de los componentes de HBS, en esta ultima se podia notar una perdida de información dado que la imagen no quedaba del todo bien. Adicionalmente se realizo la conversión a la escala de un color primario que era un trabajo trivial con las funciones de processing.
2. Con el histograma se puede ver la distribucion de brillo y con esto que aspectro se utiliza mas, si es una imagen oscura se tendra que no habran muchos tonos claros.
3. Se realizo un pequeño slide para segmentar la imagen apartir del histograma. Si se segmentaba en los valles, la imagen se perdia demasiado y si se segmentaba en los picos del histograma aun se podia visualizar y entender el contenido. 
4. Como los video utilizados eran de poca resolución se podia calcular el histograma y segmentar la imagen sin perder la fluides, con video mas grandes ya se notaban algunas fallas de rendimiento.

## Entrega

* Hacer [fork](https://help.github.com/articles/fork-a-repo/) de la plantilla. Plazo: 28/4/19 a las 24h.
* (todos los integrantes) Presentar el trabajo presencialmente en la siguiente sesión de taller.
