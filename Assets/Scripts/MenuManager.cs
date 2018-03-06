using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuManager : MonoBehaviour {
    public int LevelNumber;
    public GameObject[] LevelButtons;

    private GameObject Title;
    private GameObject LevelSelectionButton;
    private GameObject QuitButton;

    private GameObject BackButton;

    private Transform tf;

    private void Start()
    {
        tf = transform;

        Title = tf.Find("Title").gameObject;
        LevelSelectionButton = tf.Find("LevelSelection").gameObject;
        QuitButton = tf.Find("Quit").gameObject;
        BackButton = tf.Find("Back").gameObject;

        Back();
    }

    public void Back()
    {
        Title.GetComponent<UnityEngine.UI.Text>().text = "Initen GO";
        LevelSelectionButton.SetActive(true);
        QuitButton.SetActive(true);
        BackButton.SetActive(false);
        foreach (var lb in LevelButtons)
            lb.SetActive(false);
    }

    public void LevelSelection()
    {
        Title.GetComponent<UnityEngine.UI.Text>().text = "Level Selection";
        LevelSelectionButton.SetActive(false);
        QuitButton.SetActive(false);
        BackButton.SetActive(true);
        foreach (var lb in LevelButtons)
            lb.SetActive(true);
    }

    public void LoadLevel(int i)
    {
        SceneManager.LoadScene("Scene" + i);
    }

    public void Quit()
    {
        Application.Quit();
    }
}
