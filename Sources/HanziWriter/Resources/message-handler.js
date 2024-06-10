window.getMessageHandler = function (name, fn) {
  if (!name) {
    console.error("[getMessageHandler(undefined)] no name provided");
    return;
  }
  const tag = `[getMessageHandler(${name})]`;
  if (!window.webkit) {
    console.warn(`${tag} webkit not found`);
    return;
  }
  if (!window.webkit?.messageHandlers) {
    console.warn(`${tag} webkit.messageHandlers not found`);
    return;
  }
  if (!window.webkit?.messageHandlers?.[name]) {
    console.warn(`${tag} webkit.messageHandlers.${name} not found`);
    return;
  }
  if (!window.webkit?.messageHandlers?.[name]?.postMessage) {
    console.warn(`${tag} webkit.messageHandlers.${name}.postMessage not found`);
    return;
  }
  function postMessage() {
    window.webkit?.messageHandlers?.[name]?.postMessage?.(...arguments);
  }
  if (typeof fn === "function") {
    fn(postMessage);
  }
  return postMessage;
};
