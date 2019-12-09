var WebSocketServer = require('websocket').server
const mysql = require('mysql')

var conn = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "chat_node"
})

conn.connect((err) => {
    if (err) {
        console.log("DB connection error: " + err)
        return
    }
    console.log("DB connection established.")
})

var http = require('http')
var connections = []
var users = []
var chat = {
    "chatId": "22",
    "users": [],
    "history": [
        {
            "messageId": "15",
            "sender": "Ata",
            "content": "selamm"
        },
        {
            "messageId": "16",
            "sender": "Ata",
            "content": "selamm"
        },
        {
            "messageId": "17",
            "sender": "Hasan",
            "content": "naberr"
        },
        {
            "messageId": "18",
            "sender": "Ata",
            "content": "iyi valla"
        },
        {
            "messageId": "19",
            "sender": "Ata",
            "content": "sendene naber"
        },
        {
            "messageId": "20",
            "sender": "Hasan",
            "content": "bendene de iyi"
        },
    ]
}

var server = http.createServer(function (request, response) {
    console.log('created')
})

server.listen(1337, function () {

})

wsServer = new WebSocketServer({
    httpServer: server
})

wsServer.on('request', function (request) {
    var connection = request.accept(null, request.origin)
    var userId = 0

    connection.on('message', function (message) {
        console.log(message)
        if (message.type == 'utf8') {
            var data = message.utf8Data
            var jsonData = JSON.parse(data)
            if (jsonData.action == "CONNECT") {
                connectUser(connection, jsonData)
            } else {
                handleData(connection, jsonData)
            }
        }
    })
    connection.on('close', function () {
        if (connections[connection.userName]) {
            connections[connection.userName] = null //nulled here instead of removing, because we won't use whole array iteration. All we need is reach a connection from its index.
            console.log('connection closed')
        }
    })
})

async function connectUser(connection, jsonData) {
    var userName = jsonData.userName
    connection.userName = userName
    await conn.query("SELECT * FROM `users` WHERE `name` = '" + userName + "'", async (err, rows) => {
        if (err) {
            console.log("DB query error: " + err)
            return;
        }
        console.log(rows.length)
        if (rows.length == 0) {
            await conn.query("INSERT INTO `users`(`name`) VALUES ('" + userName + "')", (err) => {

            });
        }
        await conn.query("SELECT `id` FROM `users` WHERE `name`= '" + userName + "'", (err, rows) => {
            userId = rows[0].id
            connection.userId = userId
        })
        var respond = { action: "CONNECTED" }
        connection.sendUTF(JSON.stringify(respond));
    })
    connections[userName] = connection
}
function handleData(connection, jsonData) {
    switch (jsonData.action) {
        case "GET_CHAT":
            sendChat(connection)
            break;
        case "NEW_CHAT":
            jsonData.chatName
            break;
        case "GET_CHATS":
            var userId = connection.userId;
            var userName = connection.userName;
            conn.query("SELECT * FROM `chats` WHERE `userId`='" + userId + "'", (err, rows) => {
                console.log(rows);
            })
            break;
        case "GET_USERS":
            var searchName = jsonData.userName;
            conn.query("SELECT * FROM `users` WHERE `name` LIKE '%" + searchName + "%'",
                (err, rows) => {
                    if (err) {
                        console.log(err);
                    }
                    console.log("SELECT * FROM `users` WHERE `name` LIKE '%" + searchName + "%'");
                    connection.sendUTF(JSON.stringify({users:rows, action: 'GET_USERS'}))
                    console.log("rows");
                });
            break;
        case "SEND_MESSAGE": {
            var message = jsonData
            addMessage(22, message)
            for (i in chat.users) {
                var userName = chat.users[i]
                var user = connections[userName]
                console.log("chat.users")
                console.log(userName)
                console.log("chat.users")
                if (user != null) {
                    sendChat(user)
                }
            }
        }
            break;
        default:
            console.log('An unknown action has received: ' + jsonData.action)
            break;
    }
}

function sendChat(connection) {
    var respond = chat
    respond.action = "GET_CHAT"
    connection.sendUTF(JSON.stringify(respond))
}

function addMessage(chatId, message) {
    var messageId = requestMessageId(chatId)
    chat.history.push({
        "messageId": messageId,
        "chatId": message.chatId,
        "sender": message.sender,
        "content": message.content
    })
}

function requestMessageId(chatId) {
    //console.log(chat.history.length);
}