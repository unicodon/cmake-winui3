#include "SampleControl.h"

namespace muxc = winrt::Microsoft::UI::Xaml::Controls;

namespace winrt::Sample::implementation
{
    Microsoft::UI::Xaml::DependencyProperty SampleControl::m_labelProperty =
        Microsoft::UI::Xaml::DependencyProperty::Register(
            L"Label",
            winrt::xaml_typename<winrt::hstring>(),
            winrt::xaml_typename<winrt::Sample::SampleControl>(),
            Microsoft::UI::Xaml::PropertyMetadata{ winrt::box_value(L"default label"), Microsoft::UI::Xaml::PropertyChangedCallback{ &SampleControl::OnLabelChanged } }
    );

    SampleControl::SampleControl()
    {
        muxc::TextBlock text;
        text.Text(L"default label");
        auto ii = (IInspectable)(*this);
        auto ctrl = ii.as<winrt::Sample::SampleControl>();
        ctrl.Content(text);
    }

    void SampleControl::OnLabelChanged(Microsoft::UI::Xaml::DependencyObject const& d, Microsoft::UI::Xaml::DependencyPropertyChangedEventArgs const& /* e */)
    {
    }
}
