public enum CommandExecuteType
{
    ExecuteReader,
    ExecuteScalar,
    ExecuteNonQuery
}
public class SpResult<T>
{
    public bool Success { get; set; }
    public string? Message { get; set; }
    public T? Data { get; set; }
}

using System.Collections.Generic;
using System.Data.SqlClient;

public interface IStoredProcedureExecutor
{
    SpResult<List<Dictionary<string, object>>> ExecuteReader(string procedureName, Dictionary<string, object>? parameters = null);
    SpResult<int> ExecuteNonQuery(string procedureName, Dictionary<string, object>? parameters = null);
    SpResult<object> ExecuteScalar(string procedureName, Dictionary<string, object>? parameters = null);
}

using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

public class StoredProcedureExecutor : IStoredProcedureExecutor
{
    private readonly string _connectionString;

    public StoredProcedureExecutor(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")!;
    }

    public SpResult<List<Dictionary<string, object>>> ExecuteReader(string procedureName, Dictionary<string, object>? parameters = null)
    {
        var result = new SpResult<List<Dictionary<string, object>>>();
        try
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = CreateCommand(conn, procedureName, parameters);

            conn.Open();
            using var reader = cmd.ExecuteReader();
            result.Data = reader.ToDictionaryList();
            result.Success = true;
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Message = ex.Message;
        }

        return result;
    }

    public SpResult<object> ExecuteScalar(string procedureName, Dictionary<string, object>? parameters = null)
    {
        var result = new SpResult<object>();
        try
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = CreateCommand(conn, procedureName, parameters);

            conn.Open();
            result.Data = cmd.ExecuteScalar();
            result.Success = true;
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Message = ex.Message;
        }

        return result;
    }

    public SpResult<int> ExecuteNonQuery(string procedureName, Dictionary<string, object>? parameters = null)
    {
        var result = new SpResult<int>();
        try
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = CreateCommand(conn, procedureName, parameters);

            conn.Open();
            result.Data = cmd.ExecuteNonQuery();
            result.Success = true;
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Message = ex.Message;
        }

        return result;
    }

    private SqlCommand CreateCommand(SqlConnection conn, string procedureName, Dictionary<string, object>? parameters)
    {
        var cmd = new SqlCommand(procedureName, conn)
        {
            CommandType = CommandType.StoredProcedure
        };

        if (parameters != null)
        {
            foreach (var param in parameters)
            {
                cmd.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
            }
        }

        return cmd;
    }
}
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

public static class SqlDataReaderExtensions
{
    public static List<Dictionary<string, object>> ToDictionaryList(this SqlDataReader reader)
    {
        var result = new List<Dictionary<string, object>>();

        while (reader.Read())
        {
            var row = new Dictionary<string, object>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                row[reader.GetName(i)] = reader.GetValue(i);
            }
            result.Add(row);
        }

        return result;
    }
}
public class UserService
{
    private readonly IStoredProcedureExecutor _executor;

    public UserService(IStoredProcedureExecutor executor)
    {
        _executor = executor;
    }

    public void GetUserById(int userId)
    {
        var parameters = new Dictionary<string, object>
        {
            { "@UserId", userId }
        };

        var result = _executor.ExecuteReader("GetUserById", parameters);
        if (result.Success)
        {
            var userData = result.Data;
            // Map or use userData
        }
        else
        {
            Console.WriteLine("Error: " + result.Message);
        }
    }
}

//////////////////////////////////////////////////------with out parameter -----------------------------------------//////////////////////////////////////
using System.Data;

public class SpParameter
{
    public string Name { get; set; } = "";
    public object? Value { get; set; }
    public SqlDbType DbType { get; set; }
    public ParameterDirection Direction { get; set; } = ParameterDirection.Input;
    public int Size { get; set; } = 0; // Required for string/varchar output parameters
}

SpResult<List<Dictionary<string, object>>> ExecuteReader(string procedureName, List<SpParameter>? parameters = null, out Dictionary<string, object> outputParams);
SpResult<object> ExecuteScalar(string procedureName, List<SpParameter>? parameters = null, out Dictionary<string, object> outputParams);
SpResult<int> ExecuteNonQuery(string procedureName, List<SpParameter>? parameters = null, out Dictionary<string, object> outputParams);

private SqlCommand CreateCommand(SqlConnection conn, string procedureName, List<SpParameter>? parameters)
{
    var cmd = new SqlCommand(procedureName, conn)
    {
        CommandType = CommandType.StoredProcedure
    };

    if (parameters != null)
    {
        foreach (var param in parameters)
        {
            var sqlParam = new SqlParameter(param.Name, param.DbType)
            {
                Direction = param.Direction,
                Value = param.Value ?? DBNull.Value
            };

            if (param.Direction != ParameterDirection.Input && param.Size > 0)
                sqlParam.Size = param.Size;

            cmd.Parameters.Add(sqlParam);
        }
    }

    return cmd;
}
private Dictionary<string, object> GetOutputParameters(SqlCommand cmd)
{
    var outputParams = new Dictionary<string, object>();

    foreach (SqlParameter param in cmd.Parameters)
    {
        if (param.Direction == ParameterDirection.Output || param.Direction == ParameterDirection.InputOutput)
        {
            outputParams[param.ParameterName] = param.Value;
        }
    }

    return outputParams;
}


public SpResult<int> ExecuteNonQuery(string procedureName, List<SpParameter>? parameters, out Dictionary<string, object> outputParams)
{
    outputParams = new Dictionary<string, object>();
    var result = new SpResult<int>();

    try
    {
        using var conn = new SqlConnection(_connectionString);
        using var cmd = CreateCommand(conn, procedureName, parameters);

        conn.Open();
        result.Data = cmd.ExecuteNonQuery();
        outputParams = GetOutputParameters(cmd);
        result.Success = true;
    }
    catch (Exception ex)
    {
        result.Success = false;
        result.Message = ex.Message;
    }

    return result;
}
var parameters = new List<SpParameter>
{
    new SpParameter { Name = "@Name", Value = "John", DbType = SqlDbType.NVarChar },
    new SpParameter { Name = "@Email", Value = "john@example.com", DbType = SqlDbType.NVarChar },
    new SpParameter { Name = "@UserId", DbType = SqlDbType.Int, Direction = ParameterDirection.Output }
};

var result = _executor.ExecuteNonQuery("AddUser", parameters, out var output);

if (result.Success)
{
    var userId = output["@UserId"];
    Console.WriteLine($"New User ID: {userId}");
}


//////////stored procedure ------------------------------------------------------------
CREATE PROCEDURE UpsertUser
    @UserId INT = 0 OUTPUT,         -- for both input and output
    @Name NVARCHAR(100),
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId AND @UserId > 0)
    BEGIN
        -- UPDATE
        UPDATE Users
        SET Name = @Name,
            Email = @Email,
            UpdatedAt = GETDATE()
        WHERE UserId = @UserId;
    END
    ELSE
    BEGIN
        -- INSERT
        INSERT INTO Users (Name, Email, CreatedAt)
        VALUES (@Name, @Email, GETDATE());

        -- Get the inserted ID
        SET @UserId = SCOPE_IDENTITY();
    END
END
