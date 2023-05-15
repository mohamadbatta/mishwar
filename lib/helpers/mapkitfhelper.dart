import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitHelper
{
static double getMarkerRotation(sourceLat,sourceLng,destinationLat,distinationLng)
{

var rotation=SphericalUtil.computeHeading(
    LatLng(sourceLat, sourceLng),
    LatLng(destinationLat, distinationLng)
);
return rotation.toDouble();


}

}