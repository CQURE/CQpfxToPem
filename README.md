
# CQpfxToPemConverter

This project provides tools to convert `.pfx` certificate files to `.pem` format, including the private key in `.key` format. The project offers two ways to perform the conversion: using a compiled executable or a PowerShell script.

## Important
Please be adviced that you can perform this as well in Windows with openssl tool for example with command:

```bash
openssl pkcs12 -in CQtestCert.pfx -out CQtestCert.pem -nodes
```

For more usefull openssl commands check this [link from SSLShopper](https://www.sslshopper.com/article-most-common-openssl-commands.html) 

As well it is possible to use [PSPKI module](https://github.com/PKISolutions/PSPKI).

## Requirements

- .NET Framework 4.7.2 SDK to build and run the project.
- PowerShell (version 5.1 or later).
- BouncyCastle library for cryptography.

## Build the Project

### Step 1: Clone the Repository

If you haven't already, clone the repository:

```bash
git clone https://github.com/CQURE/CQpfxToPemConverter.git
cd CQpfxToPemConverter
```

### Step 2: Build the Project

Use the `.NET CLI` to build the project targeting `.NET Framework 4.7.2`.

```bash
dotnet build CQpfxToPemConverter.csproj -f net472
```

This will build the project and generate the executable file in the `bin\Debug\net472` directory.

## Running the Executable

Once the project is built, you can use the executable to convert a `.pfx` file to `.pem` format with a private key in a `.key` file.

### Command to Convert `CQtestCert.pfx` to `CQtestCert.pem` Using the Executable:

```bash
CQpfxToPemConverter.exe "CQtestCert.pfx" "CQtestCert.pem"
```

### Example:

```bash
cd bin\Debug\net472\
CQpfxToPemConverter.exe "C:\path\to\CQtestCert.pfx" "C:\path\to\CQtestCert.pem"
```

You will be prompted to enter the password for the `.pfx` file. For this example, the password is `MyTestPassword123`.

```bash
Enter password for PFX (input will be hidden):
```

## Running the PowerShell Script

Alternatively, you can run the PowerShell script `PfxToPem.ps1` to achieve the same result.

### Step 1: Ensure `BouncyCastle.Cryptography.dll` is Present

Make sure that `BouncyCastle.Cryptography.dll` is in the `libs` folder relative to the script location. If not, download it from NuGet or [BouncyCastle’s official website](https://www.bouncycastle.org/) and place it in the `libs` folder.

### Step 2: Run the PowerShell Script

You can run the PowerShell script `PfxToPem.ps1` to convert the `.pfx` file to `.pem` and `.key`.

### Command to Convert `CQtestCert.pfx` to `CQtestCert.pem` Using PowerShell:

```bash
.\PfxToPem.ps1 -pfxFilePath "C:\path\to\CQtestCert.pfx" -outputPemFilePath "C:\path\to\CQtestCert.pem"
```

You will be prompted to enter the password for the `.pfx` file. In this case, enter `MyTestPassword123`.

```bash
Enter password for PFX (input will be hidden):
```

After entering the password, the `.pem` and `.key` files will be generated in the specified location.

### Example:

```powershell
.\PfxToPem.ps1 -pfxFilePath "C:\path\to\CQtestCert.pfx" -outputPemFilePath "C:\path\to\CQtestCert.pem"
```

## Acknowledgments

- This project uses and includes the **BouncyCastle** library for cryptography, a widely used open-source library. For more information, visit the [BouncyCastle website](https://www.bouncycastle.org/).
- This project was created with the support of [ChatGPT](https://openai.com/chatgpt). ChatGPT provided guidance on building the solution and writing scripts for certificate conversion.

## License

This project is licensed under the MIT License.

---

### Key Points:
- The project targets **.NET Framework 4.7.2** (`net472`).
- The project uses the **BouncyCastle** library for cryptography to convert certificates. You can learn more about **BouncyCastle** at [bouncycastle.org](https://www.bouncycastle.org/).
- The project executable can be run directly with the `.pfx` and output `.pem` file paths.
- The PowerShell script `PfxToPem.ps1` offers an alternative way to run the conversion, prompting for the password interactively.
- A special note to acknowledge the assistance of ChatGPT in creating this project.

Let me know if you need further adjustments or clarification!