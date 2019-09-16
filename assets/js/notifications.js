export const notify = (text, options = {}) => {
  Notification.requestPermission().then(function(result) {
    switch (result) {
      case 'granted': {
        if (!document.hasFocus()) {
          new Notification(text, options)
        }
        break;
      }
      default: {
        console.log('WARNING: Notifications are not enabled')
        break;
      }
    }
  });
}
