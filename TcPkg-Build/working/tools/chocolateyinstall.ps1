$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 
$fileLocation = Join-Path $toolsDir "\LibraryToInstall.library"
$RepToolLocations = @(Join-Path "C:\Program Files (x86)\Beckhoff\TwinCAT\3.1\Components\Plc\Build_4026.*\" "Common\RepTool.exe" -Resolve)

write-host "`n`nTHE SOFTWARE IS PROVIDED `"AS IS`", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.`n" -ForegroundColor red -BackgroundColor yellow

if ($RepToolLocations.Length -gt 0) {
	$RepToolLocation = $RepToolLocations[$RepToolLocations.Length-1]
	$index = $RepToolLocation.IndexOf("\Build_4026.")
	$plcProfile = $RepToolLocation.Substring($index + 1)
	$index = $plcProfile.IndexOf("\Common\RepTool.exe")
	$plcProfile = $plcProfile.Substring(0, $index)
	$RepToolArgs = "--profile=`"TwinCAT PLC Control_$plcProfile`"", "--installLib `"$fileLocation`""
	Start-Process $RepToolLocation -ArgumentList $RepToolArgs -Wait -WindowStyle Hidden
}
