/*
 * Copyright (c) 2017, 2018, David DeHaven, All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#include <QGuiApplication>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include <QFile>
#include <QIODevice>

#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // For debugging purposes only
    qDebug() << engine.offlineStorageDatabaseFilePath("Q-Doku") << "\n";

    // Uncomment to debug various things, remove for production
//    QLoggingCategory::setFilterRules(QStringLiteral(
//        "*.debug=true\n"
//        "qt.quick.hover*=false\n"
//        "qt.scenegraph*=false\n"
//        "qt.qpa*=false\n"
//        "qt.quick.dirty*=false\n"
//        "qt.quick.mouse*=false\n"
//        "qt.quick.pointer*=false\n"
//        "qt.qml.binding*=true\n"    // requires Qt 5.10+
//    ));

    engine.addImportPath("qrc:/sudoku");
    engine.load(QUrl(QLatin1String("qrc:/ui/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
