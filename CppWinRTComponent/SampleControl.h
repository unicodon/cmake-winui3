#pragma once
#include "SampleControl.g.h"
#include <winrt/base.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.UI.Xaml.Interop.h>

namespace winrt::Sample::implementation
{
    struct SampleControl : SampleControlT<SampleControl>
    {
        SampleControl();

        hstring Label()
        {
            return winrt::unbox_value<winrt::hstring>(GetValue(m_labelProperty));
        }
        void Label(hstring const& value)
        {
            SetValue(m_labelProperty, winrt::box_value(value));
        }
        

        static Microsoft::UI::Xaml::DependencyProperty LabelProperty() { return m_labelProperty; }
        
        static void OnLabelChanged(Microsoft::UI::Xaml::DependencyObject const&, Microsoft::UI::Xaml::DependencyPropertyChangedEventArgs const&);
    private:
        static Microsoft::UI::Xaml::DependencyProperty m_labelProperty;
    };
}
namespace winrt::Sample::factory_implementation
{
    struct SampleControl : SampleControlT<SampleControl, implementation::SampleControl>
    {
    };
}
