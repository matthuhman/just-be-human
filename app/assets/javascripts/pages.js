  function showMapWithLocation(latitude, longitude) {
    var color = 'green';
    map = new google.maps.Map(document.getElementById('map'), { center: new google.maps.LatLng(latitude, longitude), zoom: 15, mapTypeId: google.maps.MapTypeId.ROAD_MAP, scaleControl: true });
    map.setOptions({ styles: styles["hide"] });
    var isClosed = false;
    var poly = new google.maps.Polyline({ map: map, path: [], strokeColor: color, strokeOpacity: 1.0, strokeWeight: 2 });
    google.maps.event.addListener(map, 'click', function (clickEvent) {
        if (isClosed)
            return;
        var markerIndex = poly.getPath().length;
        var isFirstMarker = markerIndex === 0;
        var marker = new google.maps.Marker({ map: map, position: clickEvent.latLng, draggable: true, icon: { url: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png' } });
        if (isFirstMarker) {
            google.maps.event.addListener(marker, 'click', function () {
                if (isClosed)
                    return;
                var path = poly.getPath();
                poly.setMap(null);
                poly = new google.maps.Polygon({ map: map, path: path, strokeColor: color, strokeOpacity: 0.8, strokeWeight: 2, fillColor: color, fillOpacity: 0.35 });
                isClosed = true;
                var polygonCoordinates = [];
                var coordString = "?";
                for (i = 0; i < path.length; i++) {
                  polygonCoordinates.push(path.getAt(i));
                }
                document.location.href = '/cleanups/new?authenticity_token=' + gon.auth_token + '&coordinates=' + JSON.stringify(polygonCoordinates);
                // document.location.href = '/map?location_term=80205';
            });
        }
        google.maps.event.addListener(marker, 'drag', function (dragEvent) {
            poly.getPath().setAt(markerIndex, dragEvent.latLng);
        });
        poly.getPath().push(clickEvent.latLng);
    });
  };
  const styles = {
  default: [],
  hide: [
    {
      featureType: "poi.business",
      stylers: [{ visibility: "off" }],
    },
    {
      featureType: "transit",
      elementType: "labels.icon",
      stylers: [{ visibility: "off" }],
    },
  ],
};
