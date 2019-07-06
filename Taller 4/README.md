# Taller de shaders

## Propósito

Estudiar los [patrones de diseño de shaders](http://visualcomputing.github.io/Shaders/#/4).

## Tarea

1. Hacer un _benchmark_ entre la implementación por software y la de shaders de varias máscaras de convolución aplicadas a imágenes y video.
2. Implementar un modelo de iluminación que combine luz ambiental con varias fuentes puntuales de luz especular y difusa. Tener presente _factores de atenuación_ para las fuentes de iluminación puntuales.
3. (grupos de dos o más) Implementar el [bump mapping](https://en.wikipedia.org/wiki/Bump_mapping).

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| Jesus F. Chavarro Muñoz | jesusfchavarro |

## Informe

1. Se realizo 3 convoluciones a 1 imagen de FullHD y a la misma escalada en 300x300. Los shaders mostraron una mejora cercana al 75%. Esto se puede constatar en el tiempo(en milisegundos) que toma hacer cada convolución y lo que toma todo el proceso de 3 convoluciones. En FullHD se toma en promedio 500 milisegundos y con shader se demora 150. Con la imagen de 300x300 se demora por software un promedio de 22 y con shader baja 9 milisegundos.
2. Se comparo el framerate aplicando varias convoluiones a un video obteniendo con los shader una amplia mejora en el rendimiento, sin el shader se llegaba maximo a 5 fps y cada imagen se demoraba aproximadamente 500 milisegundos en aplicar la mascara, con el shader se llegaba a 60 fps y la aplicación de la mascarada nunca era mayor a 15 milisegundos.
3. Se utilizo un ejemplo de la libreria nub "Cajas orientadas", a este se le agrego una interacción para quitar y poner la luz ambiental, se le agrego una esfera y cada esfera poseia una luz especular. Por ultimo se agrego a cada caja una luz difusa que siempre apunta a la esfera.

## Entrega

Fecha límite ~~Lunes 1/7/19~~ Domingo 7/7/19 a las 24h. Sustentaciones: 10/7/19 y 11/7/19.
