using Godot;
using System;
using System.ComponentModel;
using System.IO;
using System.IO.Ports;
using System.Text.RegularExpressions;

public class SerialInterface : Node
{
    static SerialPort _serialPort;
    private double timer = 0.0;

    [Export]
    public bool connectOnReady = false;
    [Export]
    public String port = "COM3";
    [Export]
    public int baudRate = 9600;

    private bool shouldReconnect = true;

    public override void _Ready()
    {
        
        _serialPort = new SerialPort();
        _serialPort.BaudRate = baudRate;
        _serialPort.WriteTimeout = 500;
        if (connectOnReady)
        {
            _serialPort.PortName = port;
            InitializeSerialPort();
        }
    }

    private void InitializeSerialPort()
    {
        if (!shouldReconnect)
        {
            return;
        }
        if (_serialPort.IsOpen)
        {
            _serialPort.Close();
        }
        _serialPort.PortName = port;
        _serialPort.BaudRate = baudRate;
        try
        {
            _serialPort.Open();
        }
        catch
        {
            EmitSignal("connectionError", port);
            return;
        }
    }


    public override void _ExitTree()
    {
        if (_serialPort.IsOpen)
            _serialPort.Close();
        _serialPort = null;
    }

    [Signal]
    delegate void controlReceived(int index, int type, int dataA, int dataB, int dataC);
    [Signal]
    delegate void connectionError(String port);
//  // Called every frame. 'delta' is the elapsed time since the previous frame.
  public override void _Process(float delta)
  {
    if (!_serialPort.IsOpen)
    {
        InitializeSerialPort();
        return;
    }
    if (_serialPort.PortName != port || _serialPort.BaudRate != baudRate)
    {
        InitializeSerialPort();
    }
    timer = timer + delta;
    if (timer > 0.012)
    {
        int btr;
        try
        {
            btr = _serialPort.BytesToRead;
        }
        catch (IOException)
        {
            _serialPort.Close();
            GD.PrintErr("IO exception when reading bytes.");
            EmitSignal("connectionError", port);
            btr = 0;
        }
        catch (InvalidOperationException)
        {
            _serialPort.Close();
            GD.PrintErr("Invalid op exception when reading bytes.");
            EmitSignal("connectionError");
            btr = 0;
        }
        if (btr > 0)
        {
            //GD.Print("Reading existing");
            string b = "";


            string a = _serialPort.ReadExisting();
            int index = 0;
            int type = 0;
            int dataA = 0;
            int dataB = 0;
            int dataC = 0;

            if (a != null && a != "")
            {
                int stt = 0;
                char stage = 'N';
                //GD.Print(a + "END\n");
                for (int i = 0; i < a.Length; i++)
                {
                    switch(stt)
                    {
                        case 0:
                        {
                            switch (a[i])
                            {
                                case 'I':
                                case 'T':
                                case 'A':
                                case 'B':
                                case 'C':
                                    //GD.Print("Set stage:" + stage);
                                    stage = a[i];
                                    break;
                                case ':':
                                    stt = 1;
                                    break;
                                case '\n':
                                case '\0':
                                case '\r':
                                    EmitSignal("controlReceived", index, type, dataA, dataB, dataC);
                                    //GD.Print("Sending data");
                                    break;
                                default:
                                    GD.PrintErr("Bad message:" + Convert.ToInt16(a[i]));
                                    stt = -1;
                                    i = 500000;
                                    break;
                            }
                            break;
                        }
                        case 1:
                        {
                            if (Char.IsNumber(a[i]))
                                b += a[i];
                            if (i == a.Length - 1 || !Char.IsNumber(a[i + 1]))
                            {
                                //GD.Print("stage: " + stage + "\n");
                                //GD.Print("Setting data");
                                switch(stage)
                                {
                                 case 'I':
                                        index = Convert.ToInt32(b);
                                        break;
                                    case 'T':
                                        type = Convert.ToInt32(b);
                                        break;
                                    case 'A':
                                        dataA = Convert.ToInt32(b);
                                        break;
                                    case 'B':
                                        dataB = Convert.ToInt32(b);
                                        break;
                                    case 'C':
                                        dataC = Convert.ToInt32(b);
                                        break;
                                }
                                b = "";
                                stt = 0;
                            }
                            break;
                        }
                        default:
                            break;

                    }
                }
                //EmitSignal("controlReceived", index, type, dataA, dataB, dataC);
            }
            timer = 0.0;
        }
    }
  }

  public void SendMessage(string message)
  {
    //GD.PrintErr("Sending message SND \"" + message + "\'");
    if (_serialPort != null && _serialPort.IsOpen)
    {
        //GD.Print("Writing message");
        try
        {
            _serialPort.Write(message);
            //GD.Print("Message written");
        }
        catch (InvalidOperationException)
        {
            GD.PrintErr("Invalid operation exception in send message");
            InitializeSerialPort();
        }
        catch (IOException)
        {
            GD.PrintErr("IO exception in send message");
            InitializeSerialPort();
        }
    }
    else
    {
        GD.PrintErr("Port null or closed");
    }
  }

  public void SendStatus(int health, int energy, int cargo)
  {
    String sendString = Convert.ToString(health);
    sendString += ":";
    sendString += Convert.ToString(energy);
    sendString += ":";
    sendString += Convert.ToString(cargo);
    sendString += ":\0";
    //GD.PrintErr("Sending message \"" + sendString + "\'");
    SendMessage(sendString);
  }

  public bool GetConnected()
  {
    return _serialPort.IsOpen;
  }

  public void Close()
  {
    shouldReconnect = false;
    _serialPort.Close();
  }
}
