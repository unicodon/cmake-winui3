#pragma once
#include "SampleClass.g.h"

namespace winrt::Sample::implementation
{
    struct SampleClass : SampleClassT<SampleClass>
    {
        SampleClass() = default;

        double sqrt(double x);
    };
}
namespace winrt::Sample::factory_implementation
{
    struct SampleClass : SampleClassT<SampleClass, implementation::SampleClass>
    {
    };
}
