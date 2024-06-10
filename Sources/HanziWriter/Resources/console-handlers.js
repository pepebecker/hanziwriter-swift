(function () {
  const actualConsole = window.console;

  function createConsoleHandler(type) {
    const messageHandler = window.webkit?.messageHandlers?.[`console.${type}`];
    if (!messageHandler) return actualConsole[type];
    return function (...msg) {
      const body = msg.map((e) => {
        if (typeof e === "string") return e;
        return JSON.stringify(e, null, "  ");
      });
      messageHandler.postMessage?.(body.join(" "));
      actualConsole[type](msg);
    };
  }

  window.console = {
    ...actualConsole,
    debug: createConsoleHandler("debug"),
    log: createConsoleHandler("log"),
    warn: createConsoleHandler("warn"),
    error: createConsoleHandler("error"),
  };
})();
