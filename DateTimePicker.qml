import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQml.Models 2.3
Rectangle {
    id: root
    property int timestamp: 1
    property int seconds: 1
    property int minutes: 1
    property int hours: 1
    property int day: 1
    property int weekday: 1
    property int month: 1
    property int dayofyear: 1
    property int year: 1396
    property var months: ["فروردین","اردیبهشت","خرداد","تیر","مرداد","شهریور","مهر","آبان","آذر","دی","بهمن","اسفند"]
    function calculatTime () {
        var date = new Date();
        var t = date.getTime()/1000 - 1490041861;
        seconds = t%60;
        t = (t-seconds)/60;
        minutes = t%60;
        t = (t-minutes)/60;
        hours = t%24;
        t = (t-hours)/24;
        weekday = (3 + t)%7;
        let ty = Math.floor(t/365);
        let tl = Math.floor(ty/4);// total of leap years
        t -= tl;
        dayofyear = t%365 + 1;
        year = 1396+Math.floor(t/365);
        if (dayofyear > 186) {
            month = 6 + Math.floor((dayofyear - 186)/30);
            day = dayofyear - (6 + month*30);
        }else{
            month = Math.floor(dayofyear/31);
            day = dayofyear - (month*31);
        }
        minutes++;
        seconds++;
    }
    function reCalculat () {
        let td = 0;
        if(month > 6){
            td += month*30 + 6
        }else{
            td += month*31
        }
        dayofyear = td+day
        let ly = year-1394
        let tl = Math.floor(ly/4);// total of leap years
        ly -= 2;
        td += ly*365 + tl + day
        weekday = (2 + td)%7;
    }

    function getTime () {
        timestamp = seconds + minutes*60 + hours*3600;
        let ly = year-1394
        let tl = Math.floor(ly/4);// total of leap years
        ly -= 2;
        let ld = ly*365 + dayofyear + tl
        ld *= 24 * 3600;
        timestamp += ld;
        return timestamp*1000 +1490041861000;
    }

    function creatday () {
        for(var i = theDays.children.length; i > 0 ; i--) {
                theDays.children[i-1].destroy()
              }
        let n = 31
        if(month < 6) n++;
        let w = 7 - (day- weekday -1)%7
        let m = 31 - w
        if(month < 6) m++;
        if(w < 7)
        for(var i = 0; i < w; i++)
            Qt.createQmlObject('import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
            Label {
                text: "'+m+'";
                color: "#888888"
                horizontalAlignment: Text.AlignHCenter;
                width: parent.width /7;
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(month == 0){
                            year--
                            month = 11
                        }else{
                            month--;
                        }
                        day = '+(m++)+';
                        setLabes ();
                    }
                }
            }
', theDays, "emday");
        for(var i = 1; i < n; i++)
            Qt.createQmlObject('import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
            Label {
                text: "'+i+'";
                horizontalAlignment: Text.AlignHCenter;
                width: parent.width /7;
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        day = '+i+';
                        textField.text= day +"-"+ months[month]+"-"+year+" "+hours+":"+minutes+":"+seconds;
                    }
                }
            }
', theDays, "aday");
        w =(31 - day + weekday)%7
        w=7-w;
        if(month > 5) w++;
        if(w < 7){
        for(var i = 1; i < w; i++)
            Qt.createQmlObject('import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
            Label {
                text: "'+i+'";
                color: "#888888"
                horizontalAlignment: Text.AlignHCenter;
                width: parent.width /7;
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(month == 11){
                            year++
                            month = 0
                        }else{
                            month++;
                        }
                        day = '+i+';
                        setLabes ();
                    }
                }
            }
', theDays, "emday");
}
    }

    function setLabes () {
        reCalculat ();
        textField.text= day +"-"+ months[month]+"-"+year+" "+hours+":"+minutes+":"+seconds;
        monthL.text= months[month]
        yearL.text = year
        creatday ()
    }

    Component.onCompleted:{
        calculatTime ();
        setLabes ()
        hourS.value = hours / 24
        minuteS.value = minutes / 60
        secondS.value = seconds / 60
    }


    TextField {
        id: textField
        anchors.fill: parent
        text: ""
        readOnly: true
        MouseArea {
            anchors.fill: parent
            onClicked: {
                rectangle.visible = !rectangle.visible
            }
        }
    }

    Rectangle {
        id: rectangle
        visible: true
        x: 0
        y: parent.height+5
        width: parent.width
        height: parent.width * .7
        radius: 5
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#a4fff5"
            }

            GradientStop {
                position: 0.503
                color: "#e6f5f3"
            }

            GradientStop {
                position: 1
                color: "#42e7d5"
            }


        }
        z: 90
        border.width: 0
        Rectangle{
            width: parent.width
            Label {
                id: monthL
                horizontalAlignment: Text.AlignHCenter
                width: parent.width *.5
                x: width
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        theMonths.visible = !theMonths.visible
                    }
                }
            }
            TextEdit {
                id: yearL
                horizontalAlignment: Text.AlignHCenter
                width: parent.width *.5
                Keys.onEnterPressed: {
                        year = text
                        setLabes()
                }
            }
            Grid {
                width: parent.width
                flow: Grid.LeftToRight
                layoutDirection: Qt.RightToLeft
                columns: 7
                y: monthL.height+ 5
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /7
                    text: "ش"
                }
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /7
                    text: "ی"
                }
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /7
                    text: "د"
                }
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /7
                    text: "س"
                }
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /7
                    text: "چ"
                }
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /7
                    text: "پ"
                }
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /7
                    text: "ج"
                }

            }
            Grid {
                id: theDays
                width: parent.width
                flow: Grid.LeftToRight
                layoutDirection: Qt.RightToLeft
                columns: 7
                y: monthL.height+ 35

            }
        }
        Rectangle{
            id: theMonths
            visible: false
            width: parent.width
            y: monthL.height + 5
            color: "#bbbbbb"
            Grid{
                width: parent.width
                flow: Grid.LeftToRight
                layoutDirection: Qt.RightToLeft
                columns: 4
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                Component.onCompleted: {
                    parent.height = height+30
                }

                y: 15
                Label {
                    text: "فروردین"
                    styleColor: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 0
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "اردیبهشت"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 1
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "خرداد"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 2
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "تیر"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 3
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "مرداد"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 4
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "شهریور"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 5
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "مهر"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 6
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "آبان"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 7
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "آذر"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 8
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "دی"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 9
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "بهمن"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 10
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
                Label {
                    text: "اسفند"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width /4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            month = 11
                            setLabes ()
                            theMonths.visible = false
                        }
                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            y: parent.height - 55
            height: 55
            color: "#00000000"
            Label {
                text: "ساعت"
                x: 15
                y: 5
            }
            Slider {
                id: hourS
                x: 35
                y: -4
                width: parent.width - 15
                scale: 0.5
                value: 0.5
                onValueChanged: {
                    hours = value * 23
                    textField.text= day +"-"+ months[month]+"-"+year+" "+hours+":"+minutes+":"+seconds;
                }
            }
            Label {
                text: "دقیقه"
                x: 15
                y: 20
            }
            Slider {
                id: minuteS
                scale: 0.5
                x: 35
                y: 11
                width: parent.width - 15
                value: 0.5
                onValueChanged: {
                    minutes = value * 59
                    textField.text= day +"-"+ months[month]+"-"+year+" "+hours+":"+minutes+":"+seconds;
                }
            }
            Label {
                text: "ثانیه"
                x: 15
                y: 35
            }
            Slider {
                id: secondS
                scale: 0.5
                x: 35
                y: 25
                width: parent.width - 15
                value: 0.5
                onValueChanged: {
                    seconds = value * 59
                    textField.text= day +"-"+ months[month]+"-"+year+" "+hours+":"+minutes+":"+seconds;
                }
            }
        }
    }


}
