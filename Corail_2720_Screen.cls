VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Corail_2720_Screen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'
' __        __        _    _          ____
' \ \      / /__  ___| | _| |_   _   / ___|_____   _____ _ __ __ _  __ _  ___
'  \ \ /\ / / _ \/ _ \ |/ / | | | | | |   / _ \ \ / / _ \ '__/ _` |/ _` |/ _ \
'   \ V  V /  __/  __/   <| | |_| | | |__| (_) \ V /  __/ | | (_| | (_| |  __/
'    \_/\_/ \___|\___|_|\_\_|\__, |  \____\___/ \_/ \___|_|  \__,_|\__, |\___|
'   ___  _ __    / ___|___  _|___/_ _(_) |                         |___/
'  / _ \| '_ \  | |   / _ \| '__/ _` | | |
' | (_) | | | | | |__| (_) | | | (_| | | |
'  \___/|_| |_|  \____\___/|_|  \__,_|_|_|
'
'
'01010111 01100101 01100101 01101011 01101100 01111001  01000011 01101111 01110110 01100101 01110010 01100001 01100111 01100101
'01101111 01101110  01000011 01101111 01110010 01100001 01101001 01101100
'The MIT License (MIT)
'
'Copyright (c) 2019 FORREST
' Mateusz Milewski mateusz.milewski@mpsa.com aka FORREST
'
'Permission is hereby granted, free of charge, to any person obtaining a copy
'of this software and associated documentation files (the "Software"), to deal
'in the Software without restriction, including without limitation the rights
'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
'copies of the Software, and to permit persons to whom the Software is
'furnished to do so, subject to the following conditions:
'
'The above copyright notice and this permission notice shall be included in all
'copies or substantial portions of the Software.
'
'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
'SOFTWARE.



Implements ICorailScreen


Private num As Integer


Private preUrl As String
Private screenUrl As String
Private moreRqmsUrl As String
Private url As String

Private req As HTTPRequestHandler

Private theCorailData As ICorailData

Private valid As Validator


Private Sub Class_Initialize()

    num = 2720

    screenUrl = "/getProductSummaryRead.do?beanId="
    preUrl = ".control.erp.corail.inetpsa.com"
    url = ""
    
    ' more rqms
    ' http://sx.control.erp.corail.inetpsa.com/getFbpcForProductSummaryList.do?productCode=YP000501KU
    moreRqmsUrl = "/getFbpcForProductSummaryList.do?productCode="
    
    Set req = Nothing
    
    Set valid = New Validator
End Sub

Private Sub Class_Terminate()

    preUrl = ""
    screenUrl = ""
    url = ""

    Set req = Nothing
    
    Set valid = Nothing
End Sub

Private Function ICorailScreen_getData(plt As Variant, partNumber As Variant, Optional e As E_TYPE_OF_DATA_FROM_CORAIL) As ICorailData



    Dim answer As String

    Set ICorailScreen_getData = Nothing

    If e = E_TYPE_OF_DATA_FROM_CORAIL_2720_COMMON Then

        ' -----------------------------------------------------------------------------
        url = "http://" & CStr(plt) & preUrl & screenUrl & CStr(partNumber)
        answer = req.httpGet(url)
        
        If valid.checkAnswer(num, answer) Then
            Set theCorailData = New CorailDataFrom2720
            theCorailData.setString answer
            theCorailData.parseString
        Else
            Set theCorailData = Nothing
        End If
        
        
        Set ICorailScreen_getData = theCorailData
        
        ' -----------------------------------------------------------------------------
        
    ElseIf e = E_TYPE_OF_DATA_FROM_CORAIL_2720_XTRA_RQMS Then
    
        ' -----------------------------------------------------------------------------
        url = "http://" & CStr(plt) & preUrl & moreRqmsUrl & CStr(partNumber)
        answer = req.httpGet(url)
        
        If valid.checkAnswer(num, answer) Then
            Set theCorailData = New CorailDataFrom2720
            theCorailData.setString answer
            theCorailData.parseString
        Else
            Set theCorailData = Nothing
        End If
        
        
        Set ICorailScreen_getData = theCorailData
        
        ' -----------------------------------------------------------------------------
    End If
    
End Function

Private Function ICorailScreen_getDataFrom6510(plt As Variant, vc1 As String, sc1 As String) As ICorailData

End Function

Private Function ICorailScreen_openData(plt As Variant, partNumber As Variant) As Boolean
    ICorailScreen_openData = False
End Function

Private Sub ICorailScreen_screenSetup(number As Variant, httpReq As HTTPRequestHandler)

    Set req = httpReq

End Sub
