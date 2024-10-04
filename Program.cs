using System;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.OpenSsl;
using Org.BouncyCastle.Security;

namespace CQpfxToPemConverter
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length < 2)
            {
                Console.WriteLine("Usage: CQpfxToPemConverter <pfxFilePath> <outputPemFilePath>");
                return;
            }

            string pfxFilePath = args[0];
            string outputPemFilePath = args[1];

            // Hidden password input
            Console.WriteLine("Enter password for PFX (input will be hidden):");
            string password = ReadPassword();

            try
            {
                // Load the PFX certificate
                X509Certificate2 certificate = new X509Certificate2(pfxFilePath, password, X509KeyStorageFlags.Exportable);

                // Export private key using BouncyCastle
                AsymmetricKeyParameter privateKey = DotNetUtilities.GetKeyPair(certificate.GetRSAPrivateKey()).Private;
                string privateKeyPem = ExportPrivateKeyToPem(privateKey);

                // Export certificate using BouncyCastle
                string certificatePem = ExportCertificateToPem(certificate);

                // Write the PEM files
                File.WriteAllText(outputPemFilePath + ".key", privateKeyPem);
                File.WriteAllText(outputPemFilePath, certificatePem);

                Console.WriteLine("Conversion successful. PEM and KEY files have been saved.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred: {ex.Message}");
            }
        }

        // Method to read password with hidden input
        private static string ReadPassword()
        {
            string password = string.Empty;
            ConsoleKeyInfo key;

            do
            {
                key = Console.ReadKey(intercept: true);
                if (key.Key != ConsoleKey.Enter)
                {
                    password += key.KeyChar;
                }
            } while (key.Key != ConsoleKey.Enter);

            Console.WriteLine();
            return password;
        }

        // Method to export the private key to PEM format using BouncyCastle
        private static string ExportPrivateKeyToPem(AsymmetricKeyParameter privateKey)
        {
            using (StringWriter stringWriter = new StringWriter())
            {
                PemWriter pemWriter = new PemWriter(stringWriter);
                pemWriter.WriteObject(privateKey);
                pemWriter.Writer.Flush();
                return stringWriter.ToString();
            }
        }

        // Method to export the certificate to PEM format using BouncyCastle
        private static string ExportCertificateToPem(X509Certificate2 certificate)
        {
            using (StringWriter stringWriter = new StringWriter())
            {
                PemWriter pemWriter = new PemWriter(stringWriter);
                pemWriter.WriteObject(DotNetUtilities.FromX509Certificate(certificate));
                pemWriter.Writer.Flush();
                return stringWriter.ToString();
            }
        }
    }
}
