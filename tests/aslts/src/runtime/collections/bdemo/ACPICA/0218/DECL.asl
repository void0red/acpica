/*
 * Some or all of this work - Copyright (c) 2006 - 2014, Intel Corp.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * Neither the name of Intel Corporation nor the names of its contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * Bug 218:
 *
 * SUMMARY: Access to internal object of Method is lost after returning from the recursive call to that Method
 *
 * NOTE: Reaction on the situation generated by the test should be fixed according to this:
 *
 * >-----Original Message-----
 * >From: Moore, Robert
 * >Sent: Tuesday, September 12, 2006 10:56 PM
 * >To: Moore, Robert
 * >Subject: ACPICA version 20060912 released [Code Attached]
 * >
 * >12 September 2006. Summary of changes for version 20060912:
 * >
 * >1) ACPI CA Core Subsystem:
 * >
 * > .....................
 * >
 * >Fixed a regression where an error was no longer emitted if a control method
 * >attempts to create 2 objects of the same name. This once again returns
 * >AE_ALREADY_EXISTS. When this exception occurs, it invokes the mechanism
 * >that will dynamically serialize the control method to possibly prevent
 * >future errors. (BZ 440)
 * > .....................
 */

Method(m037,, Serialized)
{
	Name(i000, 0)

	Store(id29, i000)
	Store(id29, Local0)

	Store("===== Start of test", Debug)
	Store(id29, Debug)
	Store(i000, Debug)
	Store(Local0, Debug)

	Increment(id29)

	if (LLess(id29, 10)) {
		m037()
	}

	Decrement(id29)

	Store("===== Finish of test", Debug)
	Store(id29, Debug)
	Store(i000, Debug)
	Store(Local0, Debug)

	if (LNotEqual(i000, id29)) {
		err("", zFFF, 0x000, 0, 0, i000, id29)
	}

	if (LNotEqual(Local0, id29)) {
		err("", zFFF, 0x001, 0, 0, Local0, id29)
	}
}

Method(m038) {
	CH03("", 0, 0x000, 0, 0)
	m037()
	CH03("", 0, 0x001, 0, 0)
}
