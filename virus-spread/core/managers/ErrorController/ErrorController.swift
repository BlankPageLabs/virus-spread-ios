//
//  ErrorController.swift
//  velo
//
//  Created by Илья Михальцов on 11.11.14.
//  Copyright (c) 2014 CommonSense Projects. All rights reserved.
//

import Foundation


enum Error {
    case Debug1(String)
    case Fatal(String)
    case Error(String)
}


class ErrorController: NSObject {

    private let systemExceptionHandler = NSGetUncaughtExceptionHandler()

    private var errorControllerShim: ErrorControllerExceptionShim!

    private var oldSignalHandlers: Dictionary<Int32, CFunctionPointer<(Int32) -> Void>> = [:]

    private var crashSpinnerMayRun = true

    override init() {
        super.init()

        self.errorControllerShim = ErrorControllerExceptionShim(errorController: self)

        // Enuque ErrorController initialization
        let ecShim = self.errorControllerShim

        let x = SIGTRAP

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * Int64(NSEC_PER_SEC)),
            dispatch_get_main_queue()) {
            #if DEBUG
                // Install Objective-C and/or swift exception handling
                NSSetUncaughtExceptionHandler(ecShim.exceptionHandlerShim())

                // Install BSD signal handlers
                self.oldSignalHandlers[SIGABRT] = signal(SIGABRT, ecShim.signalHandlerShim())
                self.oldSignalHandlers[SIGILL] = signal(SIGILL, ecShim.signalHandlerShim())
                self.oldSignalHandlers[SIGSEGV] = signal(SIGSEGV, ecShim.signalHandlerShim())
                self.oldSignalHandlers[SIGFPE] = signal(SIGFPE, ecShim.signalHandlerShim())
                self.oldSignalHandlers[SIGBUS] = signal(SIGBUS, ecShim.signalHandlerShim())
                self.oldSignalHandlers[SIGPIPE] = signal(SIGPIPE, ecShim.signalHandlerShim())

                // Definetely not catchable :(
                self.oldSignalHandlers[SIGTRAP] = signal(SIGTRAP, ecShim.signalHandlerShim())
            #else
                // Essentially, we want normal apple-flavored reports about crashes and user
                // would prefer the app to _just_ crash though. Hence, if we would install
                // any handlers, we would stop apple reports from being even created. There is
                // simply not much relevant unsaved data, so it would be easier to simply ignore
                // exceptions.
            #endif
        }

        // Impose NSLog onto internal log file

        // We would REALLY prefer using debugger if it's there ;)
        if !IsDebuggerAttached() {
            // Store log in documents, to retrieve through iTunes later
            let searchPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true);
            let documentsPath = (searchPaths.first as? String)!
            let logPath = documentsPath.stringByAppendingPathComponent("console.log")
            freopen(logPath.fileSystemRepresentation(), "a+", stderr);
        }

    }



    func process(error: Error) {
        switch(error) {
        case let .Debug1(message):
            #if DEBUG
                AppDelegate.instance.presentError("DEBUG", message: message)
            #else
                NSLog(message)
            #endif
        case let .Fatal(message):
            performTaskWithCrashMode {
                let alert = self.exceptionAlertViewController(title: "Fatal error",
                    message: "Fatal error: \(message)") {
                        self.crashSpinnerMayRun = false
                }
                self.createStubApplicationWindow().presentViewController(alert,
                    animated: true, completion: nil)
                self.crashObservable.fire(from: self)
            }
        case let .Error(message):
            AppDelegate.instance.presentError(NSLocalizedString("errorTitle", comment: "Error"), message: message)
        }
    }


    @objc func exceptionHandler(exception: NSException?) {
        performTaskWithCrashMode {
            let alert = self.exceptionAlertViewController(title: "Internal error",
                message: "Unrecoverable exception.\nDetails: \(exception)") {
                    self.errorControllerShim.invokeExceptionHandler(self.systemExceptionHandler,
                        withException: exception)
                    self.crashSpinnerMayRun = false
            }
            self.createStubApplicationWindow().presentViewController(alert,
                animated: true, completion: nil)
            self.crashObservable.fire(from: self)
        }
    }

    @objc func signalHandler(signal: Int32) {
        performTaskWithCrashMode {
            let alert = self.exceptionAlertViewController(title: "Internal error",
                message: "Caught signal: \(signal)") {
                self.errorControllerShim.invokeSignalHandler(self.oldSignalHandlers[signal]!,
                    withSignal: signal)
                    self.crashSpinnerMayRun = false
            }
            self.createStubApplicationWindow().presentViewController(alert,
                animated: true, completion: nil)
            self.crashObservable.fire(from: self)
        }
    }

    /// Hook onto to save data for future recovery
    var crashObservable = Observable(ErrorController)

    private func exceptionAlertViewController(#title: String,
        message: String, action: () -> Void) -> UIAlertController {

        let a = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        // XXX add report button
        a.addAction(UIAlertAction(title: "EXIT", style: .Destructive) { alertAction in
            action()
        })

        return a
    }

    // Returns a spinner object
    private func initiateCrashMode() -> (() -> Void) {
        // Here we create a controlled task-specific run loop to
        // do whatever is necessary upon crash and exit app

        let runLoop = CFRunLoopGetCurrent();
        let allModes = CFRunLoopCopyAllModes(runLoop);
        let allModesArray = allModes as NSArray

        return {
            for mode in allModesArray {
                CFRunLoopRunInMode(mode as! CFStringRef, 0.001, 0);
            }
        }
    }

    private func createStubApplicationWindow() -> UIViewController {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let viewController = UIViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return viewController
    }

    private func performTaskWithCrashMode(task: () -> Void) {
        let spinner = self.initiateCrashMode()

        task()

        while(self.crashSpinnerMayRun) {
            spinner()
        }

        fflush(stderr)
        fatalError("--> exit here <--")
    }

}

func debugMessage(message: String) {
    AppDelegate.instance.errorController.process(.Debug1(message))
}

@noreturn func fatalErrorWithUi(@autoclosure message: () -> String) {
    AppDelegate.instance.errorController.process(.Fatal(message()))
    fatalError("Unreachable code")
}

func defaultError(message: String) {
    AppDelegate.instance.errorController.process(.Error(message))
}


