using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;

public class AssociationManager : MonoBehaviour
{

	private List<Material> Initen = new List<Material>();
	public GameObject BaseIniten;
	public Transform CamAssociation;
	public float distFromCam;
	public float distFromCenter;
	public float sphereSize;
	public float launchDelay;
	public float rotationSpeed;
	public int sphereDisplayed;

	public CanvasGroup canvaGroup;
	public GameObject mainSoundButton;
	public Image buttonBackground;
	public Image associationBackground;

	private List<Button> soundButtons;

	List<GameObject> spheres = new List<GameObject>();
	AudioSource source;
	int index;

	void Start()
	{
		var tab = GameObject.FindObjectsOfType<Button>();
		mainSoundButton.transform.localScale = Vector3.zero;
		soundButtons = ButtonArrayToList(tab, false);

		if (soundButtons.Count == 0) {
			soundButtons = ButtonArrayToList(tab, true);
			SkipAssociation();
			return;
		}

		source = GetComponent<AudioSource>();
		index = 0;
		mainSoundButton.transform.parent.gameObject.SetActive(true);
		associationBackground.DOFade(0f, 2f).SetEase(Ease.OutSine).OnComplete(SetUp);
		CamAssociation.GetChild(0).position += CamAssociation.transform.forward * distFromCam;

		foreach (Material m in SaveManager.Instance.AvailableInitens) {
			Initen.Add(m);
		}
	}

	private List<Button> ButtonArrayToList(Button[] tab, bool isSkipping)
	{
		List<Button> liste = new List<Button>();

		foreach (var b in tab) {
			if (isSkipping || !SaveManager.Instance.IsSet(b.SoundToPlay)) {
				liste.Add(b);
			} else {
				b.Mat = SaveManager.Instance.GetMat(b.SoundToPlay);
				b.SetMaterials();
			}
		}

		return liste;
	}

	public void Associate(Material m, int pos, GameObject go)
	{
		SaveManager.Instance.SetMaterial(soundButtons [index].SoundToPlay, m);
		soundButtons [index].Mat = m;
		index++;
		spheres.Remove(go);

		if (index == soundButtons.Count)
			FinishAssociation();

		if (index < soundButtons.Count) {
			Invoke("PlaySound", 1f);
			if (Initen.Count > 0)
				SpawnIniten(pos, 0f);
		}
	}

	void SetUp()
	{
		mainSoundButton.transform.DOScale(1, 1f).SetEase(Ease.OutElastic, 1.5f).SetDelay(2.5f);

		for (int i = 0; i < sphereDisplayed; i++) {
			if (Initen.Count <= 0)
				break;
			SpawnIniten(i, launchDelay * i);
		}

		CamAssociation.GetChild(0).DOLocalRotate(new Vector3(0f, 0f, -360f), rotationSpeed, RotateMode.WorldAxisAdd).SetLoops(100).SetEase(Ease.Linear);
		Invoke("PlaySound", 2.5f);
	}

	void SpawnIniten(int pos, float delay)
	{
		GameObject clone = Instantiate(BaseIniten, CamAssociation.GetChild(0).position, CamAssociation.GetChild(0).rotation, CamAssociation.GetChild(0));
		clone.GetComponent<InitenClick>().associator = this;
		clone.GetComponent<InitenClick>().pos = pos;
		int m = Random.Range(0, Initen.Count);
		clone.GetComponent<MeshRenderer>().material = Initen [m];
		Initen.RemoveAt(m);
		clone.transform.Rotate(Vector3.forward, (360 / sphereDisplayed) * pos);
		clone.transform.DOLocalMove(CamAssociation.GetChild(0).InverseTransformDirection(clone.transform.up) * distFromCenter, 3f).SetEase(Ease.OutElastic, 1f).SetDelay(delay);
		clone.transform.localScale = Vector3.zero;
		clone.transform.DOScale(sphereSize, 1f).SetDelay(delay);
		spheres.Add(clone);
	}

	void PlaySound()
	{
		if (index < soundButtons.Count && soundButtons [index].SoundToPlay != null)
			source.PlayOneShot(soundButtons [index].SoundToPlay);
	}

	void FinishAssociation() // Tout le code de fin de phase
	{
		foreach (Button btn in soundButtons) {
			btn.SetMaterials();
		}

		foreach (GameObject go in spheres) {
			go.GetComponent<InitenClick>().beingKilled = true;
			go.transform.DOLocalMove(Vector3.zero, 1f).SetEase(Ease.InBack);
			go.transform.DOScale(0f, 0.9f).SetEase(Ease.InSine);
		}

		mainSoundButton.transform.DOScale(0f, 0.7f).SetEase(Ease.InSine).SetDelay(0.2f);
		Invoke("EndAssociation", 1f);
	}

	void SkipAssociation()
	{
		foreach (Button btn in soundButtons) {
			btn.SetMaterials();
		}

		mainSoundButton.transform.DOScale(0f, 0.7f).SetEase(Ease.InSine).SetDelay(0.2f);
		Invoke("EndAssociation", 1f);
	}

	void EndAssociation()  // Après FinishAssociation, quand toutes les anims sont finies
	{
		gameObject.SetActive(false);
		canvaGroup.alpha = 1f;
		buttonBackground.DOFade(0f, 2f).SetEase(Ease.OutSine);
	}
}
