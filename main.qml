import QtQuick 2.7
import QtQuick.Window 2.2
import QtLocation 5.9
import QtPositioning 5.9

//import QQuickMapboxGL 1.0

Window {
    visible: true
    width: 800
    height: 480
    title: qsTr("Nav Proto")
    color: "black"

    Item {
        PositionSource {
            active: true
            onPositionChanged: {
                map.center = position.coordinate
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
        }
    }

    Plugin {
            id: mapPlugin
            name: "mapboxgl"

            PluginParameter { name: "mapboxgl.access_token"; value: "pk.eyJ1Ijoia2l6IiwiYSI6ImNqNWxyeDhmdjJneTAyd21uMW1zaHR3MnMifQ.lASlqDzfQITFcUeuoFgkYg" }
            PluginParameter { name: "mapboxgl.mapping.additional_style_urls"; value: "mapbox://styles/kiz/cj5t06sf043ny2rqd5d5u4l47" }
    }


    Plugin {
        id: searchPlugin
        name: "here"

        PluginParameter { name: "here.app_id"; value: "K7FnHb8BUGFIuYs7Toj1" }
        PluginParameter { name: "here.token"; value: "ajKUjVRkxA-6yx_PRFvRmA" }
    }

    PlaceSearchModel {
        id: searchModel

        plugin: searchPlugin

        searchTerm: searchQuery.text
        searchArea: QtPositioning.circle(map.center);

        Component.onCompleted: { console.log(map.center); update() }
    }



    Map {
            id: map
            anchors.fill: parent
            plugin: mapPlugin
            zoomLevel: 14
            tilt: 60

            MapParameter {
                type: "source"

                property var name: "trafficSource"
                property var sourceType: "vector"
                property var url: "mapbox://mapbox.mapbox-traffic-v1"
            }

            MapItemView {
                      model: searchModel
                      delegate: MapQuickItem {
                          coordinate: place.location.coordinate

                          anchorPoint.x: image.width * 0.5
                          anchorPoint.y: image.height

                          sourceItem: Column {
                              Image { id: image; source: "/img/map-marker-2-24.png" }
                              Text { text: title; font.bold: true }
                          }
                      }
                  }

            MapItemView {
                delegate: MapQuickItem {
                    coordinate: map.center
                    zoomLevel: 17
                    sourceItem: Image {
                        id: marker
                        source: "/img/map-marker-2-24.png"
                        width:500; height:500
                    }
                }
            }
                    }

            MapParameter {
                type: "layer"

                property var name: "trafficLayer"
                property var layerType: "line"
                property var source: "trafficSource"
                property var sourceLayer: "traffic"
            }

            MapParameter {
                type: "paint"

                property var layer: "trafficSource"
                property var lineColor: "red"

            }

            MapParameter {
                type: "layout"

                property var layer: "trafficLayer"
                property var lineJoin: "round"
                property var lineCap: "round"
            }


    Rectangle {

        id: searchBox

        width: 760
        height: 60

        anchors.horizontalCenter: parent.horizontalCenter


        Image {
            source: "img/searchbar.png"
            fillMode: Image.PreserveAspectFit
            width: 760
            height: 60
        }


        NumberAnimation  on y {
            to: 20
            duration: 550
            easing.type: Easing.Linear
        }

        TextInput {
            id: searchQuery
            text: "tacos"
            font.family: "Helvetica New"
            font.pointSize: 24
            anchors.fill: parent
            anchors.margins: 16
            onAccepted: {
                console.log(text);
            }
        }
    }

    Rectangle {

        id: resultsBox

        width: 760/3.2
        height: 320
        color: "white"

        anchors.right: searchBox.right
        anchors.top: searchBox.top
        anchors.topMargin: 85

        NumberAnimation  on x {
            to: 150
            duration: 55
            easing.type: Easing.Linear
        }

        ListView {
            id: searchView
            width: parent.width
            height: parent.height
            model: searchModel
            anchors.fill: parent

            property variant placeSearchModel
            signal showPlaceDetails(variant place, variant distance)
            signal showMap()


            }
        }

    }


