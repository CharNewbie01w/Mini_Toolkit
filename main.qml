import QtQuick
import FluentUI
import org.wangwenx190.FramelessHelper
import Launcher
import RandintGenerator
import Clicker
import DataModel

FluWindow {
    id: window
    property bool fixSize: true
    property alias titleVisible: title_bar.titleVisible
    property bool appBarVisible: true
    property int windowWidth: 500
    property int windowHeight: 270
    width: windowWidth
    height: windowHeight
    closeDestory: false
    visible: true
    title: qsTr("Mini Launcher(Toolkit)")
    backgroundColor: "#dee2f2"

    signal addAppSignal(string name, string path)
    signal removeAppSignal(string name)
    signal startAppSignal(string name)
    signal setDataSignal(string name, variant value)

    Image {
        id: background_image
        source: "qrc:/res/image/background.png"
    }

    DataModel {
        id: data_model
    }

    Launcher {
        id: launcher
    }

    RandintGenerator {
        id: generator
    }

    Clicker {
        id: clicker
    }

    FramelessHelper {
        id:frameless_helper
        onReady: {
            setTitleBarItem(title_bar)
            moveWindowToDesktopCenter()
            setHitTestVisible(title_bar.minimizeButton())
            setHitTestVisible(title_bar.maximizeButton())
            setHitTestVisible(title_bar.closeButton())
            setWindowFixedSize(fixSize)
            title_bar.maximizeButton.visible = !fixSize
            if (blurBehindWindowEnabled)
                window.background = undefined
            window.show()
        }
    }

    FluAppBar {
        id: title_bar
        title: window.title
        height: 32
        visible: window.appBarVisible
        icon: "qrc:/res/image/favicon.ico"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }

    FluAcrylic {
        target: background_image
        radius: [6,6,6,6]
        tintColor: "#FFFFFFFF"
        tintOpacity: 0.72
        blurRadius: 72
        width: 490
        height: 233
        x: 5
        y: 32

        Canvas {
            FluText {
                text: "应用菜单: "
                font.pointSize: 13
                x: 10
                y: 10
            }

            FluComboBox {
                id: gameSelection
                editable: false
                width: 126
                height: 24
                x: 8
                y: 36
                model: ListModel {
                    id: gameList
                }
            }

            FluButton {
                text: "启动"
                width: 60
                x: 8
                y: 198
                onClicked: {
                    if (gameSelection.currentText !== "")
                    {
                        startAppSignal(gameSelection.currentText);
                    }
                }
            }

            FluButton {
                text: "移除"
                width: 60
                x: 74
                y: 198
                onClicked: {
                    if (gameSelection.currentText !== "")
                    {
                        removeAppSignal(gameSelection.currentText);
                        gameList.remove(gameSelection.currentIndex)
                    }
                }
            }
        }

        Rectangle {
            width: 2
            height: 200
            border.width: 1
            border.color: "#858585"
            x: 140
            y: 16
        }

        FluPivot {
            width: 344
            height: 236
            x: 149
            y: 0
            textSize: 16
            FluPivotItem {
                title: " 主界面 "
                contentItem: FluArea {
                    FluText {
                        text: "添加本地应用位置: "
                        font.pointSize: 13
                        x: 9
                        y: 9
                    }
                    FluTextBox {
                        id: path_input
                        width: 324
                        height: 30
                        x: 8
                        y: 36
                    }
                    FluText {
                        text: "自定义入口名: "
                        font.pointSize: 13
                        x: 9
                        y: 80
                    }
                    FluToggleSwitch {
                        id: name_input_switch
                        x: 288
                        y: 82
                    }

                    FluTextBox {
                        id: name_input
                        enabled: name_input_switch.checked
                        width: 324
                        height: 30
                        x: 8
                        y: 107
                    }
                    FluButton {
                        width: 80
                        x: 252
                        y: 160
                        text: "添加"
                        onClicked: {
                            var path = path_input.text;
                            var name = "";
                            var arr = path.split("\"");

                            if (path[0] === "\"" && path[path.length - 1] === "\"")
                            {
                                path = arr[1];
                            }

                            if (!name_input_switch.checked || name_input.text === "")
                            {
                                var arr_n = path.split(/[/.\\]/);
                                name = arr_n[arr_n.length - 3];
                            }
                            else
                            {
                                name = name_input.text;
                            }
                            if (name !== undefined && path !== undefined)
                            {
                                gameList.append({text: name});
                                addAppSignal(name, path);
                            }
                        }
                    }
                }
            }
            FluPivotItem {
                id: randint_generator
                title: " 随机数生成器 "
                property bool frame_0_visible: true
                property bool frame_1_visible: false
                property bool frame_2_visible: false
                contentItem: FluArea {
                    FluText {
                        text: "单次生成数量: "
                        font.pointSize: 13
                        x: 9
                        y: 9
                    }
                    FluComboBox {
                        id: generateQuantity
                        editable: false
                        width: 80
                        height: 26
                        x: 142
                        y: 9
                        model: ListModel {
                            ListElement{ text: "1" }
                            ListElement{ text: "2" }
                            ListElement{ text: "3" }
                        }
                        onCurrentIndexChanged: {
                            var num = generateQuantity.currentIndex;
                            switch (num)
                            {
                            case 0:
                                randint_generator.frame_1_visible = false;
                                randint_generator.frame_2_visible = false;
                                break;
                            case 1:
                                randint_generator.frame_1_visible = true;
                                randint_generator.frame_2_visible = false;
                                break;
                            case 2:
                                randint_generator.frame_1_visible = true;
                                randint_generator.frame_2_visible = true;
                                break;
                            }
                        }
                    }
                    FluButton {
                        width: 80
                        x: 252
                        y: 8
                        text: "重置"
                        onClicked: {
                            frame_0.min_num = ""
                            frame_1.min_num = ""
                            frame_2.min_num = ""
                            frame_0.max_num = ""
                            frame_1.max_num = ""
                            frame_2.max_num = ""
                            frame_0.result = ""
                            frame_1.result = ""
                            frame_2.result = ""
                        }
                    }

                    Canvas {
                        id: frame_0
                        width: 300
                        height: 30
                        property string result: ""
                        visible: randint_generator.frame_0_visible
                        x: 0
                        y: 48
                        property string min_num: ""
                        property string max_num: ""
                        FluText {
                            text: "随机范围: "
                            font.pointSize: 12
                            x: 9
                            y: 2
                        }
                        FluTextBox {
                            width: 80
                            height: 27
                            font.pointSize: 9
                            text: frame_0.min_num
                            x: 90
                            validator: RegularExpressionValidator { regularExpression: /\d+/ } // 限制输入为数字
                            onTextChanged: {
                                frame_0.min_num = text;
                            }
                        }
                        FluText {
                            text: "~"
                            font.pointSize: 12
                            x: 172
                            y: 2
                        }
                        FluTextBox {
                            width: 80
                            height: 27
                            font.pointSize: 9
                            text: frame_0.max_num
                            x: 190
                            validator: RegularExpressionValidator { regularExpression: /\d+/ } // 限制输入为数字
                            onTextChanged: {
                                frame_0.max_num = text;
                            }
                        }
                        FluText {
                            text: parent.result
                            font.pointSize: 12
                            color: "#1181cc"
                            x: 280
                            y: 2
                        }
                    }
                    Canvas {
                        id: frame_1
                        width: 300
                        height: 30
                        visible: randint_generator.frame_1_visible
                        property string result: ""
                        x: 0
                        y: 84
                        property string min_num: ""
                        property string max_num: ""
                        FluText {
                            text: "随机范围: "
                            font.pointSize: 12
                            x: 9
                            y: 2
                        }
                        FluTextBox {
                            width: 80
                            height: 27
                            font.pointSize: 9
                            text: frame_1.min_num
                            x: 90
                            validator: RegularExpressionValidator { regularExpression: /\d+/ } // 限制输入为数字
                            onTextChanged: {
                                frame_1.min_num = text;
                            }
                        }
                        FluText {
                            text: "~"
                            font.pointSize: 12
                            x: 172
                            y: 2
                        }
                        FluTextBox {
                            width: 80
                            height: 27
                            font.pointSize: 9
                            text: frame_1.max_num
                            x: 190
                            validator: RegularExpressionValidator { regularExpression: /\d+/ } // 限制输入为数字
                            onTextChanged: {
                                frame_1.max_num = text;
                            }
                        }
                        FluText {
                            text: parent.result
                            font.pointSize: 12
                            color: "#1181cc"
                            x: 280
                            y: 2
                        }
                    }
                    Canvas {
                        id: frame_2
                        width: 300
                        height: 30
                        visible: randint_generator.frame_2_visible
                        property string result: ""
                        x: 0
                        y: 120
                        property string min_num: ""
                        property string max_num: ""
                        FluText {
                            text: "随机范围: "
                            font.pointSize: 12
                            x: 9
                            y: 2
                        }
                        FluTextBox {
                            width: 80
                            height: 27
                            font.pointSize: 9
                            text: frame_2.min_num
                            x: 90
                            validator: RegularExpressionValidator { regularExpression: /\d+/ } // 限制输入为数字
                            onTextChanged: {
                                frame_2.min_num = text;
                            }
                        }
                        FluText {
                            text: "~"
                            font.pointSize: 12
                            x: 172
                            y: 2
                        }
                        FluTextBox {
                            width: 80
                            height: 27
                            font.pointSize: 9
                            text: frame_2.max_num
                            x: 190
                            validator: RegularExpressionValidator { regularExpression: /\d+/ } // 限制输入为数字
                            onTextChanged: {
                                frame_2.max_num = text;
                            }
                        }
                        FluText {
                            text: parent.result
                            font.pointSize: 12
                            color: "#1181cc"
                            x: 280
                            y: 2
                        }
                    }

                    FluButton {
                        width: 80
                        x: 252
                        y: 160
                        text: "执行"
                        onClicked: {
                            var temp = "";
                            if (frame_0.min_num > frame_0.max_num)
                            {
                                temp = frame_0.min_num;
                                frame_0.min_num = frame_0.max_num;
                                frame_0.max_num = temp;
                            }
                            if (frame_1.min_num > frame_1.max_num)
                            {
                                temp = frame_1.min_num;
                                frame_1.min_num = frame_1.max_num;
                                frame_1.max_num = temp;
                            }
                            if (frame_2.min_num > frame_2.max_num)
                            {
                                temp = frame_2.min_num;
                                frame_2.min_num = frame_2.max_num;
                                frame_2.max_num = temp;
                            }

                            if (frame_0.min_num.length && frame_0.max_num.length)
                            {
                                var num0 = generateRandomNumber(frame_0.min_num, frame_0.max_num);
                                frame_0.result = num0;
                            }
                            if (frame_1.min_num.length && frame_1.max_num.length)
                            {
                                var num1 = generateRandomNumber(frame_1.min_num, frame_1.max_num);
                                frame_1.result = num1;
                            }
                            if (frame_2.min_num.length && frame_2.max_num.length)
                            {
                                var num2 = generateRandomNumber(frame_2.min_num, frame_2.max_num);
                                frame_2.result = num2;
                            }
                        }
                    }
                }
            }
            FluPivotItem {
                title: " 开发测试 "
                contentItem: FluArea {
                    FluButton {
                        text: "发送信号"
                        onClicked: {
                            setDataSignal("testTitle", "testText");
                            console.log(data_model.data["testTitle"]);
                        }
                    }
                }
            }
            FluPivotItem {
                title: " 设置 "
                contentItem: FluArea {

                }
            }
        }
    }

    Component.onCompleted: {
        window.onAddAppSignal.connect(launcher.addAppSlot);
        window.onRemoveAppSignal.connect(launcher.removeAppSlot);
        window.onStartAppSignal.connect(launcher.startSlot);
        window.onSetDataSignal.connect(data_model.setDataSlot);
        launcher.appList = data_model.data["appList"];
        var keys = launcher.getAppNames();
        for (var i = 0; i < keys.length; i++)
        {
            gameList.append( {text: keys[i]} );
        }

//        console.log(keys);
    }

    closeFunc: function(event) {
        var map = launcher.appList;
        setDataSignal("appList", map);
        event.accepted = true;
    }

    function setHitTestVisible(com) {
        framless_helper.setHitTestVisible(com)
    }
    function setTitleBarItem(com) {
        framless_helper.setTitleBarItem(com)
    }
    function generateRandomNumber(min, max) {
        var randomNumber = generator.ranNum % (max - min + 1) + (min - "0");

        return randomNumber;
    }

}
