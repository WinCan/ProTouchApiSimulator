#include "UdpVideoController.h"
#include <QFile>
#include <iostream>
#include "GStreamer.h"

struct UdpVideoController::Pimpl
{
    Pimpl()
    {
        tryLoadGstreamerLibraries();
        if(gst_init.isResolved())
        {
            gst_init(nullptr, nullptr);
        }
    }
    void startPipeline(const QString& ip, const QString& port)
    {
        auto pipeline = "videotestsrc is-live=true do-timestamp=true "
                        "! video/x-raw,width=1280,height=720 "
                        "! autovideoconvert "
                        "! queue leaky=downstream "
                        "! x264enc tune=zerolatency "
                        "! h264parse "
                        "! rtph264pay pt=96 "
                        "! udpsink host=" + ip + " port=" + port;
        gstPipeline = gst_parse_launch(pipeline.toStdString().c_str(), nullptr);
        gst_element_set_state(gstPipeline, GST_STATE_PLAYING);
    }

    void stop()
    {
        if(gstPipeline != nullptr)
        {
            gst_element_set_state(gstPipeline, GST_STATE_NULL);
            gst_object_unref(gstPipeline);
            gstPipeline = nullptr;
        }
    }

    bool hasGstreamer()
    {
        return gst_init.isResolved()
           and gst_parse_launch.isResolved()
           and gst_element_set_state.isResolved();
    }
    GstElement* gstPipeline = nullptr;
};

UdpVideoController::UdpVideoController(QObject* parent)
    : QObject(parent)
{
    pimpl = std::make_unique<Pimpl>();
}

void UdpVideoController::startPipeline(const QString &beginning, const QString& ip, const QString& port)
{
    //autovideosrc's dlls are probably not deployed with PT, so forced videotestsrc
    (void)beginning;
    return pimpl->startPipeline(ip, port);
}

void UdpVideoController::stop()
{
    return pimpl->stop();
}

bool UdpVideoController::hasGstreamer()
{
    return pimpl->hasGstreamer();
}

UdpVideoController::~UdpVideoController() = default;
