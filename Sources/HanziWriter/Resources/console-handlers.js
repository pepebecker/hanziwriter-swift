function createConsoleHandler(key) {
  return function(...msg) {
    window.webkit.messageHandlers[key].postMessage(msg.map((e) => {
      if (typeof e === 'string') return e
      return JSON.stringify(e, null, '  ')
    }).join(' '));
  }
}

window.console.log = createConsoleHandler('console.log')
window.console.warn = createConsoleHandler('console.warn')
window.console.error = createConsoleHandler('console.error')
