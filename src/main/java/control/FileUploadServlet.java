package control;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.file.*;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

//@WebServlet(urlPatterns={"/myservlet"})
@MultipartConfig
public class FileUploadServlet extends HttpServlet {
    private final static Logger LOGGER = Logger.getLogger(FileUploadServlet.class.getCanonicalName());
    private static final long serialVersionUID = 7908187011456392847L;


    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Create path components to save the file
        final String fileId = request.getParameter("imageId");
        final String path = (request.getServletContext().getRealPath("")) + "/image/images";

        final Part filePart = request.getPart("file");
        final String fileName = getFileName(filePart);

        OutputStream out = null;
        InputStream filecontent = null;
        final PrintWriter writer = response.getWriter();
        System.out.println("Содамем: " + path + File.separator + fileId+".jpg");

        try {

            out = new FileOutputStream(new File(path + File.separator + fileId+".jpg"));
            filecontent = filePart.getInputStream();

            int read;
            final byte[] bytes = new byte[1024];

            while ((read = filecontent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
            writer.println("New file " + fileName + " created at " + path);
            LOGGER.log(Level.INFO, "File {0} being uploaded to {1}",
                       new Object[]{fileName, path});

        } catch (FileNotFoundException fne) {
            writer.println("You either did not specify a file to upload or are "
                                   + "trying to upload a file to a protected or nonexistent "
                                   + "location.");
            writer.println("<br/> ERROR: " + fne.getMessage());

            LOGGER.log(Level.SEVERE, "Problems during file upload. Error: {0}",
                       new Object[]{fne.getMessage()});
        } finally {
            if (out != null) {
                out.close();
            }
            if (filecontent != null) {
                filecontent.close();
            }
            if (writer != null) {
                writer.close();
            }
        }
    }

    private String getFileName(final Part part) {
        final String partHeader = part.getHeader("content-disposition");
        LOGGER.log(Level.INFO, "Part Header = {0}", partHeader);
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(
                        content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getParameter("removeFile")!=null){
            String s = request.getParameter("removeFile");
            removeImage(request.getServletContext().getRealPath("") + s.substring(s.indexOf("/image/")));
//            removeImage(request.getServletContext().getRealPath("") + request.getParameter("removeFile"));
        } else if(request.getParameter("removeNewFile")!=null) {
            String s = request.getParameter("removeNewFile");
            String ph = s.substring(s.indexOf("/image/"));
            int i = 1;
            while (i < 6) {
                removeImage(request.getServletContext().getRealPath("") + ph + "_" + i + ".jpg");
                i++;
            }
        } else{
            processRequest(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet that uploads files to a user-defined destination";
    }

    protected void removeImage(String url){
        System.out.print("Удаляем: " + url);
        try {
            Path path = Paths.get(url);
            Files.delete(path);
        } catch (NoSuchFileException x) {
            System.out.format("%s: no such" + " file or directory%n", url);
        } catch (DirectoryNotEmptyException x) {
            System.out.format("%s not empty%n", url);
        } catch (IOException x) {
            System.err.println(x);
        }
    }
}
