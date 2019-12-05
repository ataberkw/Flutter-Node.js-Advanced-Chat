const
  io = require("socket.io")(),
  server = io.listen(8000);

let
  sequenceNumberByClient = new Map();

var chats = [];

var chat = {
  "chat_id": "chat_22",
  "history": {
    1: {
      "message_id": "15",
      "sender": "userid_1",
      "content": "selamm"
    },
    2: {
      "message_id": "16",
      "sender": "userid_1",
      "content": "selamm"
    },
    3: {
      "message_id": "17",
      "sender": "userid_2",
      "content": "naberr"
    },
    4: {
      "message_id": "18",
      "sender": "userid_1",
      "content": "iyi valla"
    },
    5: {
      "message_id": "19",
      "sender": "userid_1",
      "content": "sendene naber"
    },
    6: {
      "message_id": "20",
      "sender": "userid_2",
      "content": "bendene de iyi"
    },
  }
}

chats[chat.chat_id] = chat

// event fired every time a new client connects:
server.on("connection", (socket) => {
  console.info(`Client connected [id=${socket.id}]`)
  // initialize this client's sequence number
  sequenceNumberByClient.set(socket, 1)

  // when socket disconnects, remove it from the list:
  socket.on("disconnect", () => {
    sequenceNumberByClient.delete(socket)
    console.info(`Client disconnected [id=${socket.id}]`)
  });
});

var chat = server.of('/chat').on('connection', (socket) => {
  socket.on('chatReq', (req) => {
    console.log(socket)
    socket.emit('chatTrans', [getChat(req.chat_id)])
  });
  socket.on('sendMessage', (req) => {
    sendMessage(req.sender, req.to, req.content);
  });
});

//TODO: create chat room

function getChat(chatId) {
  for (const key in chats) {
    if (key == chatId) {
      console.log("Chat gotten: " + chatId)
      return chats[key];
    }
  }
  console.log("Couldn't get chat: " + chatId)
  return null
}

function sendMessage(sender, chatId, content) {
  var chat = chats[chatId]
  var chatHistory = chat.history
  var chatLength = 0
  for (key in chatHistory) {
    if (chatHistory.hasOwnProperty(key)) chatLength++
  }
  chats[chatId].history[++chatLength] = message(newMessageId, content, sender, chatId)
  console.log('')
  console.log('I guess we added a msg by ' + sender + ' to ' + chatId + " and content: " + content)
  console.log(chats)
}

function message(newMessageId, content, sender, chatId) {
  return {
    "message_id": newMessageId,
    "content": content,
    "sender": sender,
    "chat_id": chatId
  }
}

function newMessageId(chatId) {
  var chatHistory = chats[chatId].history
  var msgLength = 0
  for (msg in chatHistory) {
    if (chatHistory.hasOwnProperty(msg)) msgLength++
  }
  console.log('')
  console.log('It looks like I added a new message :o')
  return msgLength++
}

class Message {
  Message(messageId, content, sender, chatId) {
    var messageId
    var content
    var sender
    var chatId
  }
}