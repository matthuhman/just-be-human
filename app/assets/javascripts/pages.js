
///////////////// constants

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





/////////////////

var pageMode = 'show';


let map;
let coordinatesJson;
let cleanups;

function showEditModeMap(latLng) {
  showSubmitButton(false);
  showCancelButton(true);
  showEditModeButton(false);

  pageMode = 'edit';
  coordinatesJson = null;
  var color = 'green';
  map = new google.maps.Map(document.getElementById('map'), { center: latLng, zoom: 16, mapTypeId: google.maps.MapTypeId.ROAD_MAP, disableDefaultUI: true, scaleControl: true });
  map.setOptions({ styles: styles["hide"] });
  map.setOptions({ clickableIcons: false });
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
              finishedPolygon = new google.maps.Polygon({ map: map, path: path, strokeColor: color, strokeOpacity: 0.8, strokeWeight: 2, fillColor: color, fillOpacity: 0.35 });
              isClosed = true;
              var polygonCoordinates = [];
              var coordString = "?";
              for (i = 0; i < path.length; i++) {
                polygonCoordinates.push(path.getAt(i));
              }
              coordinatesJson = JSON.stringify(polygonCoordinates);
              showSubmitButton(true);
              // document.location.href = '/cleanups/new?authenticity_token=' + gon.auth_token + '&coordinates=' + JSON.stringify(polygonCoordinates);
              // document.location.href = '/map?location_term=80205';
          });
      }
      google.maps.event.addListener(marker, 'drag', function (dragEvent) {
          poly.getPath().setAt(markerIndex, dragEvent.latLng);
      });
      poly.getPath().push(clickEvent.latLng);
  });
};

function showMapsWithCleanups(latLng) {
  pageMode = 'show';
  showSubmitButton(false);
  showCancelButton(false);
  showEditModeButton(true);
  map = new google.maps.Map(document.getElementById('map'), { center: latLng, zoom: 13.5, mapTypeId: google.maps.MapTypeId.ROAD_MAP, disableDefaultUI: true, scaleControl: true });
  map.setOptions({ styles: styles["hide"] });
  map.setOptions({ clickableIcons: false });
  let infoWindow = new google.maps.InfoWindow();
  for (i = 0; i < cleanups.length; i++) {
     var path = []
     var cleanup = cleanups[i];
     cleanup.contentString =
        `<div id="marker-content">
              <div id="siteNotice"></div>
              <h4 id="marker-title" class="marker-title">Participants: ${cleanup.participants}</h4>
              <div id="marker-participants" class="marker-participants">Small bags collected: ${cleanup.small_bags}</div>
              <div id="marker-followers" class="marker-followers">Buckets collected: ${cleanup.buckets}</div>
         </div>`;
     var coordinates = cleanup['coordinates'];
     for (j = 0; j < coordinates.length; j++) {
        path.push({lat: parseFloat(coordinates[j][0]), lng: parseFloat(coordinates[j][1])})
     }
     var poly = new google.maps.Polygon({ map: map, path: path, strokeColor: cleanup['age'], fillColor: cleanup['age'], fillOpacity: 0.75, strokeOpacity: 1.0, strokeWeight: 2 });



      (function (poly, cleanup) {
        google.maps.event.addListener(poly, "click", function (e) {
          infoWindow.setContent(cleanup.contentString);
          infoWindow.open(map);
          infoWindow.setPosition(e.latLng);
        });
      })(poly, cleanup);

      //marker.addListener('click', assignListener(marker, infoWindow));

     // google.maps.event.addListener(poly, "click", function (event) {
     //      infoWindow.setContent(cleanup.contentString);
     //      infoWindow.setPosition(event.latLng);
     //      infoWindow.open(map);
     //    });
  }
  // map.addListener("click", function() {
  //   infoWindow.close();
  // });
}


function showMapWithCleanups(latitude, longitude, cleanupsJson) {
  if (gon.auth_token == 'NONE') {
    showCreateAccountModal();
  }
  cleanups = cleanupsJson;
  var latLng = new google.maps.LatLng(parseFloat(latitude), parseFloat(longitude))
  showMapsWithCleanups(latLng);
};

function showCreateAccountModal() {
  var times = parseInt(window.localStorage.getItem('shownCreateAccountModal'));
  console.log('times shown:' + times);
  if (times && times < 10) {
    window.localStorage.setItem('shownCreateAccountModal', times + 1);
    return;
  } else {
    var modal = document.getElementById("create-account-modal");
    modal.style.display = "block";
    window.localStorage.setItem('shownCreateAccountModal', 1);
  }
}

function hideCreateAccountModal() {
  var modal = document.getElementById("create-account-modal");
  modal.style.display = "none";
}


function enableEditMode() {
  if (pageMode == 'show') {
    showEditModeMap(map.getCenter());
  }
}

function submitNewCleanup() {
  if (coordinatesJson != null) {
    document.location.href = '/cleanups/new?authenticity_token=' + gon.auth_token + '&coordinates=' + coordinatesJson;
  }
}

function disableEditMode() {
  if (pageMode == 'edit') {
    showMapsWithCleanups(map.getCenter());
  }
}

function showSubmitButton(visible) {
  var x = document.getElementById("submit-new-cleanup-btn");
  if (visible) {
    x.style.display = "block";
  } else {
    x.style.display = "none";
  }
}

function showCancelButton(visible) {
  var x = document.getElementById("disable-edit-mode-btn");
  if (visible) {
    x.style.display = "block";
  } else {
    x.style.display = "none";
  }
}

function showEditModeButton(visible) {
  var x = document.getElementById("enable-edit-mode-btn");
  if (visible) {
    x.style.display = "block";
  } else {
    x.style.display = "none";
  }
}












