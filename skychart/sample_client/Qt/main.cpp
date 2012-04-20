#include <QApplication>

#include "cdcClient.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    CdcClient cdcclient;
    cdcclient.show();
    QObject::connect(&app, SIGNAL(aboutToQuit()), &cdcclient, SLOT(quitting()));
    return app.exec();
}
