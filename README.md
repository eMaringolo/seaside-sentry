# seaside-sentry
Integration of Sentry error tracking platform as Seaside middleware

# Installation

```smalltalk
Metacello new 
  baseline: 'SeasideSentry'; 
  repository: 'github://eMaringolo/seaside-sentry/source'; 
  load.
```

# How to use

`WASentryExceptionFilter` is just another exception handler, but it contains a "parent" handler, which is the regular exception handler class that will likely report the exception to the user.


```smalltalk
handler := WAAdmin defaultDispacher handlerAt: 'yourApp'.
filter := WASentryExceptionFilter new.
Sentry showNotification: false.
handler addFilter: filter.
handler exceptionHandler: WASentryErrorHandler.
filter configuration at: #dsn put: "yourSentryDSN".
"After reporting to Sentry, continue with regular exception handling, using the 'parent' handler."
filter configuration
  at: #parentExceptionHandler
  put: WAErrorHandler.
```
