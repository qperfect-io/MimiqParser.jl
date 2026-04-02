#
# Copyright © 2023-2026 QPerfect. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

function toproto(bv::BitVector)
    return utils_pb.BitVector(length(bv), bitarr_to_bytes(bv))
end

function fromproto(bv::utils_pb.BitVector)
    return BitString(bytes_to_bitarr(bv.data, bv.len))
end

function toproto(bv::BitString)
    return toproto(bv.bits)
end

function fromproto(v::utils_pb.ComplexVector)
    return fromproto.(v.data)
end

function fromproto(v::utils_pb.ComplexDouble)
    return ComplexF64(v.real, v.imag)
end

function toproto(v::Vector{ComplexF64})
    return utils_pb.ComplexVector(toproto.(v))
end

function toproto(v::ComplexF64)
    return utils_pb.ComplexDouble(real(v), imag(v))
end