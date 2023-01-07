# seaside-sentry
Integration of Sentry error tracking platform as Seaside middleware


# How to use

```smalltalk
handler := WAAdmin defaultDispacher handlerAt: 'yourApp'.
filter := WASentryException Filter new.
Sentry showNotification: false.
handler addFilter: filter.
handler exceptionHandler: WASentryErrorHandler.
filter configuration at: #dsn put: "yourSentryDSN".
"After reporting to Sentry, continue with regular exception handling, using the 'parent' handler."
filter configuration
  at: #parentExceptionHandler
  put: WAErrorHandler.
```
