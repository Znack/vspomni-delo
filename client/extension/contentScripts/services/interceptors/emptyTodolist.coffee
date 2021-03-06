module.exports = (response)->
  if response instanceof Array and not response.length
    chrome.runtime.sendMessage {
      backendName: "notificationBackend"
      method: 'create'
      params:
        type: "basic"
        title: "У вас нет созданных дел"
        message: "Нажмите на иконку расширения и кликните \"Создать новое дело\""
        iconUrl: "img/128x128.png"
        notificationName: "emptyTodolistNotification"
    }, (response)->
  return response