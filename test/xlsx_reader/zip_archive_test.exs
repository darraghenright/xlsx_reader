defmodule XlsxReader.ZipArchiveTest do
  use ExUnit.Case

  alias XlsxReader.ZipArchive

  describe "list/1" do
    test "lists the contents of a zip file" do
      zip_handle = ZipArchive.handle(TestFixtures.path("test.zip"), :path)

      assert {:ok, ["dir/subdir/file3.bin", "file1.txt", "file2.dat"]} =
               ZipArchive.list(zip_handle)
    end

    test "lists the contents of a zip buffer" do
      zip_handle = ZipArchive.handle(TestFixtures.read!("test.zip"), :binary)

      assert {:ok, ["dir/subdir/file3.bin", "file1.txt", "file2.dat"]} =
               ZipArchive.list(zip_handle)
    end

    test "invalid zip file" do
      zip_handle = ZipArchive.handle(TestFixtures.path("not_a_zip.zip"), :path)

      assert {:error, "invalid zip file"} = ZipArchive.list(zip_handle)
    end

    test "zip file not found" do
      zip_handle = ZipArchive.handle("__does_not_exist__", :path)

      assert {:error, "file not found"} = ZipArchive.list(zip_handle)
    end
  end

  describe "extract/2" do
    test "extracts a file from a zip file" do
      zip_handle = ZipArchive.handle(TestFixtures.path("test.zip"), :path)

      assert {:ok, "Contents of file1\n"} = ZipArchive.extract(zip_handle, "file1.txt")
      assert {:ok, "Contents of file2\n"} = ZipArchive.extract(zip_handle, "file2.dat")
      assert {:ok, "Contents of file3\n"} = ZipArchive.extract(zip_handle, "dir/subdir/file3.bin")

      assert {:error, "file \"bogus.bin\" not found in archive"} =
               ZipArchive.extract(zip_handle, "bogus.bin")
    end

    test "extracts a file from zip buffer" do
      zip_handle = ZipArchive.handle(TestFixtures.path("test.zip"), :path)

      assert {:ok, "Contents of file1\n"} = ZipArchive.extract(zip_handle, "file1.txt")
      assert {:ok, "Contents of file2\n"} = ZipArchive.extract(zip_handle, "file2.dat")
      assert {:ok, "Contents of file3\n"} = ZipArchive.extract(zip_handle, "dir/subdir/file3.bin")

      assert {:error, "file \"bogus.bin\" not found in archive"} =
               ZipArchive.extract(zip_handle, "bogus.bin")
    end

    test "invalid zip file" do
      zip_handle = ZipArchive.handle(TestFixtures.path("not_a_zip.zip"), :path)

      assert {:error, "invalid zip file"} = ZipArchive.extract(zip_handle, "file1.txt")
    end

    test "zip file not found" do
      zip_handle = ZipArchive.handle("__does_not_exist__", :path)

      assert {:error, "file not found"} = ZipArchive.extract(zip_handle, "file1.txt")
    end
  end
end
